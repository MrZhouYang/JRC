function[time,accurate] = dis_JRC( A,Y ,class,l)
% ���������������ܶ�ʱ�������ʱ�俪�����ܴ󣬿��ǽ������������
% �ֿ���ʾ��ʶ��
global test_num
class_num = length(class);
Y1 = Y(:,1:class_num*test_num/2);
Y2 = Y(:,(class_num*test_num/2+1):end);
class1 = class(1:class_num/2);
class2 = class((class_num/2+1):end);
AA = A;
lambda = l ;
[time1, accurate_num1] = JRC(AA,Y1,class1,lambda);
[time2,accurate_num2] = JRC(AA,Y2,class2,lambda);
time = time1 + time2;
accurate = (accurate_num1 + accurate_num2)/(class_num);
end