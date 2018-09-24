function ImgCandy=Candy(img)
Img_GaussFilter=GuassFilter(img);
Img_Gtadient=Gradient(Img_GaussFilter);
Img_Gtadient_NMS=NMS(Img_Gtadient);
ImgCandy=Img_Gtadient_NMS;
end

%高斯滤波平滑
function ImgGuassFilter=GuassFilter(img)
gausFilter = fspecial('gaussian',[5 5],1.6);%生成高斯滤波器
ImgGuassFilter=imfilter(img,gausFilter,'replicate');%卷积边缘采用复制边缘
end

%梯度计算
function ImgGradient=Gradient(img)
%Sobel算子
Sobel=[-1 0 1;
        -2 0 2;
        -1 0 1];
Gy=abs(imfilter(img,Sobel','replicate'));%Y梯度幅值
Gx=abs(imfilter(img,Sobel,'replicate'));%X梯度幅值
ImgGradient=sqrt(Gx.^2+Gy.^2);%梯度
end

%8邻域抑制
function ImgNMS=NMS(img)
ImgNMS=img;
[m,n]=size(img);
for i=1:m
    for j=1:n
        region=img(max(i-1,1):min(i+1,m),max(j-1,1):min(j+1,n));
        b=sort(region(:),'descend');
        if img(i,j)<b(3)
            ImgNMS(i,j)=0;
        end            
    end
end
%
%单阈值二值化
%
ImgNMS=imbinarize(ImgNMS,(max(ImgNMS(:))+min(ImgNMS(:)))/2);
end
