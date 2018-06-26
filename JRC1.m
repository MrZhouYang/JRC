function [del] = JRC1()%��������
%time: �������е�ʱ��
%accurate ʶ�����ȷ��
%feature_num ÿ��ͼƬ��������
%clear;clc
global class_db train_num test_num class
%   ����ȫ�ֱ���
train_num = 4; %ÿ����ѵ��ͼƬ�ĸ���
test_num = 2; %ÿ�������ͼƬ�ĸ���
class_db = 50 ;  %���������������ĸ���
feature_num = 150;
A = read_image;     %��ȡͼƬ��Ϊѵ������
% A = A6 ;
% class = [20] ;

prompt = '�������ͼƬ�������[1,2,3]��ʾ��1��2��3��ͼƬ\n';
class = input(prompt);
% test_class_num = 30;  %��������������
% rand('seed',8);
% rand_class = randperm(class_db);%����ͼƬ�����,�������ѡȡ���ҵ�30������ͼƬ��˳��
% class = rand_class(1:test_class_num);
% class_db = length(class);  %������
Y = read_image(class);      %��ȡ��������
%%%%%%%%%%%%    PCA������ͼƬ��ά
A = double(A');
A = zscore(A);  %���Ļ�
[coeff,score] = pca(A);
A = score(:,1:feature_num);
A = A';
Y = double(Y');
Y = zscore(Y);  %���Ļ�
Y = Y*coeff(:,1:feature_num);
Y = Y';%���ڵ�A��Y���ǽ�ά���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% train_num = 4; %ÿ����ѵ��ͼƬ�ĸ���
% class_db = 25 ;  %���������������ĸ���
% A = unifrnd(-20,20,60,100);
% Y = unifrnd(-20,20,60,30);
% ʹ�õ����������ϡ�����X
t0 = clock;
% ��������
epsilon1 = 10^-5;
p = 1; 
lambda = 10;  %��ʼ��lambda
sigma = 10^-10;
[m,d] = size(A);  %ѵ�����������غ͸���
n = size(Y,2);  %���������ĸ���
rand('seed',1);
X1 = rand(d,n);  %�����ʼ��һ��X
% X1 = ones(d,n);
rho = 1;    %��ʼ��һ��rho����ΪJ1 �� J2�����

%ÿ��ѵ��ͼƬ�����ָ��
train_index = meshgrid(1:class_db ,1:train_num);
train_index = train_index(:);
train_index = train_index';
train.subindex = meshgrid(1:train_num,1:class_db);
train.subindex = train.subindex';
train_index(2,:) = train.subindex(:);
j=0;  % ������¼һ�µ����Ĳ���
del = [];
W = eye(d);
while rho > epsilon1    
%     d = size(X1,1);
    X1_norm = arrayfun(@(i)norm(X1(i,:)),1:d); %����Xÿһ�е�2��
    % ��X1 ���н��нض�
%     X1_norm_s = find(X1_norm <= sigma); %�����з���С��sigma����ָ��
%     X1(X1_norm_s,:) = []; %ȥ����Щ��
%     A(:,X1_norm_s) =  []; %A ��Ӧ����ȥ��
% %     ��¼��ȥ����ָ�ꡣ
%     del = [del,train_index(:,X1_norm_s)];
%     train_index(:,X1_norm_s) = []; %����ָ��,ȥ����Ӧ����
%     X1_norm(X1_norm_s) = [];
     %%%%%%%%%%%%%
%      Ȩ��
%     for i = 1:class_db
%        w(i) = sum(X1_norm((train_num * (i - 1) +1 ) : train_num * i)); 
%     end
%     W = meshgrid(w,1:train_num);
%     W = 1./W;
%     W = W(:);
%     W = diag(W); %���ɶԽ���
%     %%%%%

    H = diag(1./(X1_norm.^(2 - p)));   %����H��k�����Խ�Ԫ��A��i��2�����ĵ�����2-p���ݵĶԽǾ���
%     H = W*H;%��Ȩ�ز����з����ֲ�
    M = A'*A + 1/2*lambda*H;
    C = A'*Y;
    opts.POSDEF = true;opts.SYM = true;
    X2 = linsolve(M,C,opts);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    J1 = trace( ( A*X1 - Y )'*( A*X1 - Y ) ) + lambda*trace( X1'*H*X1 );
    J2 = trace( ( A*X2 - Y )'*( A*X2 - Y ) ) + lambda*trace( X2'*H*X2 );
    rho = 1 - J2/J1;
    X1 = X2;

end
%%%%%%%%    X����������漴����X����ͼƬ��ʶ��
X = X1;
%   ���ض�
% X1_norm_s = find(X1_norm <= sigma); %�����з���С��sigma����ָ��
% del = train_index(:,X1_norm_s);
%%%%%%%%%%%%%%%%%%

% del = sortrows(del');      %���һ��ɾ�����е����
% del = del';
% uni_del = unique(del(1,:));
% l_del = length(uni_del);

% �������Xÿһ���2����������
d = size(X1,1);
xx = arrayfun(@(i)norm(X(i,:)),1:d); % X��ÿһ��ȡ2����
figure(2)
bar(xx,'b')
xlabel('ѵ����ͼ��')
ylabel('������ȡ������Ĵ�С')
axis([0,d,0,max(xx)]);
% t1 = clock;
% time = etime(t1,t0);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %����X���з����ж�
% for i = 1:length(class)
%     T_Y = zeros(size(Y));
%     T_Y(:,test_num*(i-1) + 1 :test_num*i) = Y(:,test_num*(i-1) + 1 :test_num*i);
%     for j = 1:class_db
%        T_X = zeros(size(X)); 
%        T_X(train_num*(j-1)+1 : train_num*j,:) = X(train_num*(j-1)+1 : train_num*j,:);
%        error.matrix = T_Y - A*T_X;
%        norm_value(j) = norm( error.matrix(:,test_num*(i-1) + 1 :test_num*i),2 );
%     end
%     err(:,i) = norm_value;
%     min_norm(i) = min(norm_value); %����ֵ��С���Ǹ�
%     arg_min(i) = find(norm_value == min_norm(i)); 
% end
% time = etime(clock,t0)
% true1 = class == arg_min;    %��ȷΪ1������Ϊ0
% accurate = sum(true1)/length(true1)%��ȷ��
end