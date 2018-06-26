function [time,accurate_num] = JRC( A,Y ,class,l) %�㷨֮��Ƚ�
% function [time,accurate_num] = JRC( A,Y ,class)

%function [true,err] = JRC( A,Y ,class) %�����ع����
%function [accurate] = JRC(A,Y,class,test_num) %�㷨����Ƚ�
%time: �������е�ʱ��
%accurate ʶ�����ȷ��
global class_db train_num test_num class % ����ȫ�ֱ���
% train_num = 4; %ÿ����ѵ��ͼƬ�ĸ���
% test_num = 2; %ÿ�������ͼƬ�ĸ���
% class_db = 50 ;  %���������������ĸ���
t0 = clock;
% ʹ�õ����������ϡ�����X
epsilon1 = 10^-5;
% lambda = 230;  %��ʼ��lambda
lambda = l;
rho = 1;    %��ʼ��һ��rho����ΪJ1 �� J2�����
[m,d] = size(A);  %ѵ�����������غ͸���
n = size(Y,2);  %���������ĸ���
rand('seed',6);
X1 = rand(d,n);  %�����ʼ��һ��X
% X1 = ones(d,n);
% train_index = meshgrid(1:class_db ,1:train_num);
% train_index = train_index(:)';   %ÿ��ѵ��ͼƬ�����ָ��
% iteration=0;  % ������¼�����Ĳ���
delete_col = [];
while rho > epsilon1
    % ��X1 ���н��нض�
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
% delete_col = sort(unique(delete_col));        %���һ��ɾ�����е����
%����X���з����ж�
% class = meshgrid(class,1:test_num);
% class = class(:);   %���в�����Ƭ�����
% all_test = size(Y,2);%���в���ͼ��ĸ���
for i = 1:length(class)
% for i = 1:all_test
    T_Y = zeros(size(Y));
    T_Y(:,test_num*(i-1) + 1 :test_num*i) = Y(:,test_num*(i-1) + 1 :test_num*i);
%       y = Y(:,i);
    for j = 1:class_db
       T_X = zeros(size(X)); 
       T_X(train_num*(j-1)+1 : train_num*j,:) = X(train_num*(j-1)+1 : train_num*j,:);
       error.matrix = T_Y - A*T_X;
%        norm_value(j) = norm( error.matrix(:,test_num*(i-1) + 1 :test_num*i),'fro' );
       norm_value(j) = norm(error.matrix,'fro');
%        x1 = zeros(size(X,1),1);
%        x1(train_num*(j-1)+1 : train_num*j) = X(train_num*(j-1)+1 : train_num*j,i);
    end
    min_norm(i) = min(norm_value); %����ֵ��С���Ǹ�
    arg_min(i) = find(norm_value == min_norm(i));  
end

true1 = class == arg_min;    %��ȷΪ1������Ϊ0
accurate_num = sum(true1);
accurate = sum(true1)/length(true1); %��ȷ��
%  %������ʱ
time = etime(clock,t0);

end