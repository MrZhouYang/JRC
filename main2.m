clear;clc;
% ƽ������½��
global class_db train_num test_num  test_class_num d_min d_max 
class_db = 100; %ͼƬ����𣨲�ͬ����������
train_num = 5; %ÿ����ѵ��ͼƬ�ĸ���
test_num = 3; %ÿ�������ͼƬ�ĸ���
test_class_num = 80;  %��������������
d_min = 10;  %ά�ȵ���Сֵ
d_max = 300; %ά�ȵ����ֵ
load('ATT.mat'); % ����ѵ������
load('FEI.mat');
A = FEI;   

dimision =  d_min : 30 : d_max;
% A = read_image;     %��ȡͼƬ��Ϊѵ������
%%%%%%%%%%%%    PCA������ͼƬ��ά
A = double(A');
A = zscore(A);  %���Ļ�
[coeff,score,latent] = pca(A);
for j = 1:5
    i = 1;
    rand_class = randperm(class_db);%����ͼƬ�����,�������ѡȡ���ҵ�30������ͼƬ��˳��
    class = rand_class(1:test_class_num);
    Y = read_image(class);      %��ȡ��������
    Y = double(Y');
    Y = zscore(Y);  %���Ļ�
    for dim = dimision
        A1 = score(:,1:dim);
        A1 = A1';
        Y1 = Y*coeff(:,1:dim);
        Y1 = Y1';
    %���ڵ�A��Y���ǽ�ά���    
%        [jrc_time(i,j),jrc_accurate(i,j)] = JRC(A1,Y1,class);
       [jrc_time(i,j),jrc_accurate(i,j)] = dis_JRC(A1,Y1,class);
       [src_time(i,j),src_accurate(i,j)] = SRC(A1,Y1,class);
       [pca_time(i,j),pca_accurate(i,j)] = pca_test(A1,Y1,class);
       [svm_time(i,j),svm_accurate(i,j)] = svm(A1,Y1,class);
       i= i+1;
    end  
end
mjrc_time = mean(jrc_time,2);mjrc_accurate = mean(jrc_accurate,2);
msrc_time = mean(src_time,2);msrc_accurate = mean(src_accurate,2);
mpca_time = mean(pca_time,2);mpca_accurate = mean(pca_accurate,2);
msvm_time = mean(svm_time,2);msvm_accurate = mean(svm_accurate,2);
% 
% vjrc_time = var(jrc_time,2);vjrc_accurate = var(jrc_accurate,2);
% vsrc_time = var(src_time,2);vsrc_accurate = var(src_accurate,2);
% vpca_time = var(pca_time,2);vpca_accurate = var(pca_accurate,2);
% vsvm_time = var(svm_time,2);vsvm_accurate = var(svm_accurate,2);
% 
dimision = dimision';
figure(1)
% subplot(2,2,3);
plot(dimision,mjrc_time,'-*')
hold on
plot(dimision,msrc_time,'-o')
hold on 
plot(dimision,mpca_time,'-^')
hold on 
plot(dimision,msvm_time,'-+')
title('ʱ��Ա�ͼ');
xlabel('ͼ������ά��');
ylabel('ʱ��(s)');
legend('JRC','SRC','PCA','SVM');
axis([d_min,d_max,-1,50]);

% subplot(2,2,4);
figure(2)
plot(dimision,100*mjrc_accurate,'-*')
hold on
plot(dimision,100*msrc_accurate,'-o')
hold on
plot(dimision,100*mpca_accurate,'-^')
hold on
plot(dimision,msvm_accurate,'-+')
title('ʶ���ʶԱ�ͼ');
xlabel('ͼ������ά��');
ylabel('ʶ����(%)');
legend('JRC','SRC','PCA','SVM');
axis([d_min,d_max,0,100]);