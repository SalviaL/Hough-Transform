function ImgCandy=Candy(img)
Img_GaussFilter=GuassFilter(img);
Img_Gtadient=Gradient(Img_GaussFilter);
Img_Gtadient_NMS=NMS(Img_Gtadient);
ImgCandy=Img_Gtadient_NMS;
end

%��˹�˲�ƽ��
function ImgGuassFilter=GuassFilter(img)
gausFilter = fspecial('gaussian',[5 5],1.6);%���ɸ�˹�˲���
ImgGuassFilter=imfilter(img,gausFilter,'replicate');%�����Ե���ø��Ʊ�Ե
end

%�ݶȼ���
function ImgGradient=Gradient(img)
%Sobel����
Sobel=[-1 0 1;
        -2 0 2;
        -1 0 1];
Gy=abs(imfilter(img,Sobel','replicate'));%Y�ݶȷ�ֵ
Gx=abs(imfilter(img,Sobel,'replicate'));%X�ݶȷ�ֵ
ImgGradient=sqrt(Gx.^2+Gy.^2);%�ݶ�
end

%8��������
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
%����ֵ��ֵ��
%
ImgNMS=imbinarize(ImgNMS,(max(ImgNMS(:))+min(ImgNMS(:)))/2);
end
