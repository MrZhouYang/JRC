function [ A ] = read_image( class )
%function [ A ] = read_image( class,test_num )
global class_db train_num test_num   % ����ȫ�ֱ���
%   class_db ��Ҫ��ȡ��Ƭ�����Ĭ�϶�ȡ������������Ϊѵ����
%   ����A��Ϊ��ȡͼƬ�ľ�������A��ÿһ����Ϊһ��������ͼƬ��
% class_db = 50; %ͼƬ����𣨲�ͬ����������
% train_num = 4; %ÿ����ѵ��ͼƬ�ĸ���
% test_num = 2; %ÿ�������ͼƬ�ĸ���

if nargin == 0      %Ĭ�ϲ�����Ĭ������¶�ȡѵ��ͼƬ
    class = 1:class_db;
    each_class = 2:2:2*train_num;   %ÿ��att_face��(��)��ȡ��ͼƬ��Ĭ�϶�ǰ����
    %each_class = [110];
elseif nargin ~= 0
    %each_class = (train_num+1) : (train_num+test_num);  %��Ҫatt_faceȡ�Ĳ���ͼƬ
    each_class = 1:2:2*test_num; 
%     each_class = [1,10];
end

A_col = 0; %�����������A������

for i = class
    
    for j = each_class
         %att_face database
        file_path =fullfile('F:\face database\att_faces',strcat('s',int2str(i)),int2str(j));   
        temp = imread(strcat(file_path,'.pgm'));
        
        %%%%%%%%%%%%%%%%%   
%         FEI face database

%         if j < 10
%             file_path = fullfile('F:\face database\FEI Face Database\images',...
%                 strcat(int2str(i),'-0',int2str(j)));
%         else
%             file_path = fullfile('F:\face database\FEI Face Database\images',...
%                 strcat(int2str(i),'-',int2str(j)));
%         end
%         temp = imread(strcat(file_path,'.jpg'));
%         temp = imresize(temp,[480,640]);    %��ͼƬͳһ��С
%         temp = rgb2gray(temp);  %RGB ͼ��ת��Ϊ grayͼ��
%         temp = temp(1:10:480,1:10:640);%�²���
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        [m,n] = size(temp);
        A(:,A_col + 1 ) =  reshape(temp',[m*n,1]);
        A_col = size(A,2);  %����A������
    end
end

end