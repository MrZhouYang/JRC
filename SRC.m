% function [time,accurate] = SRC( A,Y ,class ,l)
% function [time,accurate] = SRC( A,Y ,class)
function [true,err] = SRC( A,Y ,class)
%time: �������е�ʱ��
%accurate ʶ�����ȷ��
%feature_num ÿ��ͼƬ��������
%clear;clc;
global class_db train_num test_num  % ����ȫ�ֱ���
% train_num = 5; %ÿ����ѵ��ͼƬ�ĸ���
% test_num = 2; %ÿ�������ͼƬ�ĸ���
% class_db = 100 ;  %���������������ĸ���
t0 = clock; %��ʼʱ��
cla = meshgrid(class,1:test_num);
cla = cla(:);   %���в�����Ƭ�����
all_test = size(Y,2);%���в���ͼ��ĸ���

for i = 1:all_test
   y = Y(:,i);
%    x = lasso(A,y,'lambda',0.1);
   x = lasso(A,y,'lambda',l);
   for j = 1:class_db
       x1 = zeros(size(x));
       x1(train_num*(j-1)+1 : train_num*j) = x(train_num*(j-1)+1 : train_num*j);
       y1(j) = norm(y - A*x1);
   end
%    err(:,i) = y1;
    m_y1 = find(y1 == min(y1));
    if(length(m_y1)<2)
        arg_min(i,:) = m_y1; %ʶ������
    else
       arg_min(i,:) =  m_y1(1);
    end
   
end
true = cla == arg_min;
accurate = sum(true)/all_test;  %׼ȷ��
%toc;%��ʱ����
time = etime(clock,t0);
%end
end