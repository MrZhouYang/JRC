clear;clc;
% ����һ��ȫ�ֱ���
global class_db train_num test_num  test_class_num d_min d_max 
class_db = 100; %ͼƬ����𣨲�ͬ����������
train_num = 5; %ÿ����ѵ��ͼƬ�ĸ���
test_num = 3; %ÿ�������ͼƬ�ĸ���
test_class_num = 80;  %��������������
d_min = 10;
d_max = 250; %ά�ȵ����ֵ
load('ATT.mat');% ����ѵ������
load('FEI.mat');
A = FEI;
rand('seed',8);
rand_class = randperm(class_db);%����ͼƬ�����,�������ѡȡ���ҵ�30������ͼƬ��˳��
class = rand_class(1:test_class_num);
dimision =  d_min :30 : d_max;

lambda = [0.001,0.01,0.1,1,10,100,300,1000] ;
dim = 200;

% A = read_image;     %��ȡͼƬ��Ϊѵ������
%%%%%%%%%%%%    PCA������ͼƬ��ά
A = double(A');
A = zscore(A);  %���Ļ�
[coeff,score,latent] = pca(A);
Y = read_image(class);      %��ȡ��������
Y = double(Y');
Y = zscore(Y);  %���Ļ�
j = 1;
for dim = dimision
% for l = lambda
    A1 = score(:,1:dim);
    A1 = A1';
    Y1 = Y*coeff(:,1:dim);
    Y1 = Y1';
    %���ڵ�A��Y���ǽ�ά���    
%     [jrc_time(j),jrc_accurate(j)] = JRC(A1,Y1,class);
%     [jrc_time(j),jrc_accurate(j)] = dis_JRC(A1,Y1,class);
%     [src_time(j),src_accurate(j)] = SRC(A1,Y1,class);
%     [pca_time(j),pca_accurate(j)] = pca_test(A1,Y1,class);
%     [svm_time(j),svm_accurate(j)] = svm(A1,Y1,class);

    [jrc_time(j,:),jrc_accurate(j,:)] = dis_JRC(A1,Y1,class,l);
    [src_time(j,:),src_accurate(j,:)] = SRC(A1,Y1,class,l);
   
    j=j+1;
end  
lambda = lambda';
figure(1)
semilogx(lambda,jrc_time,'-*')
hold on
semilogx(lambda,src_time,'-o')

% plot(dimision,jrc_time,'-*')
% hold on
% plot(dimision,src_time,'-o')
% hold on 
% plot(dimision,pca_time,'-^')
% hold on 
% plot(dimision,svm_time,'-+')
% title('ʱ��Ա�ͼ');
% xlabel('lambda');
% ylabel('ʱ��(s)');
% legend('JRC','SRC','PCA','SVM');
% axis([d_min,d_max,-1,50]);
legend('JRC','SRC');

figure(2)
semilogx(lambda,100*jrc_accurate,'-*')
hold on
semilogx(lambda,100*src_accurate,'-o')


% plot(dimision,100*jrc_accurate,'-*')
% hold on
% plot(dimision,100*src_accurate,'-o')
% hold on
% plot(dimision,100*pca_accurate,'-^')
% hold on
% plot(dimision,svm_accurate,'-+')
% % title('ʶ������lambda��ϵ');
% title('ʶ���ʶԱ�ͼ');
% xlabel('����ά��');
% ylabel('ʶ����(%)');
% legend('JRC','SRC','PCA','SVM');
% axis([d_min,d_max,0,100]);
legend('JRC','SRC');
