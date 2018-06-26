function [time,accurate] = pca_test(A,Y,class )
%ʹ�����ɷַ����ķ�����������ʶ��
%ÿ������ѵ������ֻѡȡ5��ͼƬ
%time: �������е�ʱ��
%accurate ʶ�����ȷ��
%feature_num ÿ��ͼƬ��������
%clear;clc;
% train_num = 5; %ÿ����ѵ��ͼƬ�ĸ���
% test_num = 2; %ÿ�������ͼƬ�ĸ���
% class_db = 100 ;  %���������������ĸ���
global class_db train_num test_num 
% ����ȫ�ֱ���

t0 = clock;
if 0
A = read_image;     %��ȡͼƬ��Ϊѵ������
%prompt = '�������ͼƬ�����1��40������[1,2,3]��ʾ��1��2��3��ͼƬ\n';
%class = input(prompt);
%class_db = [2];
Y = read_image(class);      %��ȡ��������
%tic;%��ʱ��ʼ
t0 = clock;
%%%%    downsample�²���
%if 0
A = downsample(double(A),100);
Y = downsample(double(Y),100);
%end
%%%%

%%%%%%%%%%%%    PCA������ͼƬ��ά
A = double(A');
A = zscore(A);  %���Ļ�
[coeff,score,latent] = pca(A);
l = cumsum(latent)/sum(latent);
p_num = sum(l<=0.95);%�趨һ����ֵ0.95���������ɷֵĸ���
if nargin == 0
    feature_num = p_num;
end
A = score(:,1:feature_num);
A = A';
Y = double(Y');
Y = zscore(Y);  %���Ļ�
Y = Y*coeff(:,1:feature_num);
Y = Y';
end
%���ڵ�A��Y���ǽ�ά���
%ʹ�����ɷַ��������ʱ���A���б�ʾѵ������ר��ÿ�����ϡ��
%Y��ʾ�������������ɷֵ�ϵ��
cla = meshgrid(class,1:test_num);
cla = cla(:);   %���в�����Ƭ�����
all_test = size(Y,2);%���в���ͼ��ĸ���
%������ھ����������б�
%�������ͼƬ��train_num��ͼƬ�ľ����
for i = 1:all_test
   y = Y(:,i);
   for j = 1:class_db
       count = 0;
       for k = 1:train_num
           count = count +norm(y - A(:,train_num*(j-1)+k));
       end
       e(j) = count;
   end
   arg_min(i,:) = find(e == min(e)); %ʶ������
end
true = cla == arg_min;
accurate = sum(true)/all_test;  %׼ȷ��
%toc;%��ʱ����
%t1=clock;
time = etime(clock,t0);
end


