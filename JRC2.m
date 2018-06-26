function [true1,err] = JRC2( A,Y ,class) %�����ع����
global class_db train_num test_num % ����ȫ�ֱ���
% train_num = 4; %ÿ����ѵ��ͼƬ�ĸ���
% test_num = 2; %ÿ�������ͼƬ�ĸ���
% class_db = 50 ;  %���������������ĸ���
% ʹ�õ����������ϡ�����X
epsilon1 = 10^-5;
% lambda = 230;  %��ʼ��lambda
lambda = 200;
rho = 1;    %��ʼ��һ��rho����ΪJ1 �� J2�����
[m,d] = size(A);  %ѵ�����������غ͸���
n = size(Y,2);  %���������ĸ���
rand('seed',6);
X1 = rand(d,n);  %�����ʼ��һ��X
while rho > epsilon1
    d = size(X1,1);
    X1_norm = arrayfun(@(i)norm(X1(i,:)),1:d); %����Xÿһ�е�2����
    H = diag(1./X1_norm);   %����H��k�����Խ�Ԫ��A��i��2�����ĶԾ�����
%     G = ones(m);    %��Ϊ��ʱ��q= 2��GΪ��λ����Ҳ���Բ����
    M = A'*A + 1/2*lambda*H;
    C = A'*Y;
    opts.POSDEF = true;
    opts.SYM = true;
    X2 = linsolve(M,C,opts);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    J1 = trace( ( A*X1 - Y )'*( A*X1 - Y ) ) + lambda*trace( X1'*H*X1 );
    J2 = trace( ( A*X2 - Y )'*( A*X2 - Y ) ) + lambda*trace( X2'*H*X2 );
    rho = 1 - J2/J1;
    X1 = X2;
end
%%%%%%%%    X����������漴����X����ͼƬ��ʶ��
%%%%%%%%    �������Ҽ������ͼƬ�������ݿ���
X = X1;
for i = 1:length(class)
    T_Y = zeros(size(Y));
    T_Y(:,test_num*(i-1) + 1 :test_num*i) = Y(:,test_num*(i-1) + 1 :test_num*i);
    for j = 1:class_db
       T_X = zeros(size(X)); 
       T_X(train_num*(j-1)+1 : train_num*j,:) = X(train_num*(j-1)+1 : train_num*j,:);
       error.matrix = T_Y - A*T_X;
%        norm_value(j) = norm( error.matrix(:,test_num*(i-1) + 1 :test_num*i),'fro' );
       norm_value(j) = norm(error.matrix,'fro');
%        x1 = zeros(size(X,1),1);
%        x1(train_num*(j-1)+1 : train_num*j) = X(train_num*(j-1)+1 : train_num*j,i);
    end
    err(:,i) = norm_value;
    min_norm(i) = min(norm_value); %����ֵ��С���Ǹ�
    arg_min(i) = find(norm_value == min_norm(i));  
end

true1 = class == arg_min;    %��ȷΪ1������Ϊ0

end