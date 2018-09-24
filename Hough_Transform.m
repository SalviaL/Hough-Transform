%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڽ��л���任��ȡֱ��
% ����ͼƬΪRGB��ʽͼƬ������Ϊ�ҶȻ��ֵͼƬ
% ���ֶ�����ͼƬ�ļ�������ȡֱ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Hough_Transform

clc,clear
img_name='test5.jpg';            %ֱ����
line_num=6;                      %ֱ������

%
%%����任
%

img=double(rgb2gray(imread(img_name)))/255; %ͼ��ҶȻ�
img=imnoise(img,'salt & pepper',0.02);
[m,~]=size(img);
Img_Candy=Candy(img);                       %Candy��Ե��ȡ
[r,t]=Hough(Img_Candy,line_num);            %����任
imshow(img)                                 %���ԭͼ��
hold on
%
%%����ֱ��
%
for i=1:size(r)
    a=r(i)/cos(t(i));
    b=r(i)/sin(t(i));
    x=1:m;
    y=(a*b-b*x)/a;
    plot(x,y,'LineWidth',1.3)
    hold on;
end
end

%
%����任
%
function [r,t]=Hough(img,line_num)
t_step=pi/1000; %�Ȳ���pi/1000
r_step=0.5;     %�Ѳ���0.5
[m,n]=size(img);
r=[];
t=[];
count=0;
hold on
for i=1:m
    for j=1:n
        if img(i,j)==1
            for th=0:t_step:pi
                r=[r (i+0.5)*sin(th)+(j+0.5)*cos(th)];
                t=[t th];
                count=count+1;
            end
        end
    end
end
[Vote,C]=hist3([r',t'],[floor(range(r)/r_step),floor(pi/t_step)]);
imshow(Vote,[])
[r,t]=GetMax(Vote,C,line_num);
end

%
%��ȡǰnum�����ֵ��
%
function [r,t]=GetMax(vote,C,num)
[m,n]=size(vote);
r=[];
t=[];
for count=1:num
    indexi=0;
    indexj=0;
    note=0;
    for i=1:m
        for j=1:n
            if vote(i,j)>note
                indexi=i;
                indexj=j;
                note=vote(i,j);
            end
        end
    end
    vote(indexi,indexj)=0;
    vote(max(indexi-10,1):min(indexi+10,m),max(indexj-10,1):min(indexj+10,n))=0;
    %
    %ͶƱ���ռ�ת����ռ�
    %
    t=[t C{1,2}(indexj)];
    r=[r C{1,1}(indexi)];
end
t=t';
r=r';
end