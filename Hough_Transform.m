%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本程序用于进行霍夫变换提取直线
% 读入图片为RGB格式图片，不能为灰度或二值图片
% 需手动设置图片文件名和提取直线数量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Hough_Transform

clc,clear
img_name='test5.jpg';            %直线名
line_num=6;                      %直线数量

%
%%霍夫变换
%

img=double(rgb2gray(imread(img_name)))/255; %图像灰度化
img=imnoise(img,'salt & pepper',0.02);
[m,~]=size(img);
Img_Candy=Candy(img);                       %Candy边缘提取
[r,t]=Hough(Img_Candy,line_num);            %霍夫变换
imshow(img)                                 %输出原图像
hold on
%
%%绘制直线
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
%霍夫变换
%
function [r,t]=Hough(img,line_num)
t_step=pi/1000; %θ步长pi/1000
r_step=0.5;     %ρ步长0.5
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
%获取前num个最大值点
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
    %投票器空间转霍夫空间
    %
    t=[t C{1,2}(indexj)];
    r=[r C{1,1}(indexi)];
end
t=t';
r=r';
end