%class = randperm(100);%����ͼƬ�����,�������ѡȡ���ҵ�30������ͼƬ��˳��

% Ѱ��JRC�ܹ�ʶ�𣬶�SRC����ʶ�����Ƭ������
clear;clc
global class_db train_num test_num  % ����ȫ�ֱ���
class_db = 100; %ͼƬ����𣨲�ͬ����������
train_num = 5; %ÿ����ѵ��ͼƬ�ĸ���
test_num = 2; %ÿ�������ͼƬ�ĸ���
test_class_num = 90;  %��������������

class = 1:90;
% A = read_image;     %��ȡͼƬ��Ϊѵ������
load('ATT.mat'); % ����ѵ������
load('FEI.mat');
A = FEI;
A = double(A');
A = zscore(A);  %���Ļ�
[coeff,score,latent] = pca(A);
Y = read_image(class);
Y = double(Y');
Y = zscore(Y);  %���Ļ�
A = score(:,1:200);
A = A';   
Y = Y*coeff(:,1:200);
Y = Y';
[true1,err1] = SRC2(A,Y,class);
[true2,err2] = JRC2(A,Y,class);
j = 1;
for i = 1:80
   if(true2(i) & ~(true1(2*i -1) & true1(2*i) ) )
       err(j) = i;
       j = j+1;
   end
end

j = 73;
err_j = err2(:,j);
err_s1 = err1(:,2*j -1);
err_s2 = err1(:,2*j);

plot(1:100,err_j,'o','MarkerFaceColor','b')
hold on
plot(1:100,err_s1,'*',1:100,err_s2,'+')
legend('JRC-����ͼ��','SRC-ͼ��1','SRC-ͼ��2')
y = find( err_s1 == min(err_s1));
hold on
plot(y,err_s1(y),'ko','markersize',13)
%hold on
%plot(1:100,err1(:,68),'*')
y = find(err_s2 == min(err_s2));
hold on
plot(y,err_s2(y),'bo','markersize',13)
hold on
%plot(1:100,err2(:,34),'v')
y = err_j;
%hold on 
plot(j,y(j),'ko','markersize',13)
xlabel('�������');
ylabel('���');
