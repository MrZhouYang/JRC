function [time,accrate] = svm(A,Y,class)
% train_num = 5; %ÿ����ѵ��ͼƬ�ĸ���
% test_num = 2; %ÿ�������ͼƬ�ĸ���
% class_db = 100 ;  %���������������ĸ���
global class_db train_num test_num 
% ����ȫ�ֱ���

t0 = clock;
train_label_vector = meshgrid(1:class_db,1:train_num);
train_label_vector = train_label_vector(:);
test_label_vector = meshgrid(class,1:test_num);
test_label_vector = test_label_vector(:);
A = A';
Y = Y';
model = svmtrain(train_label_vector,A,'-t 0');
[ predicted_label,accuracy,decision_values] = svmpredict(test_label_vector,Y,...
                                                model);
accrate = accuracy(1);
time = etime(clock,t0);

end