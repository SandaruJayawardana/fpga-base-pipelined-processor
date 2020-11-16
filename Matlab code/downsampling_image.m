instrfind
delete(instrfind)
img = imread('Lena.png');
gray_=rgb2gray(img);

[rows,columns]=size(gray_);
%disp(size(gray_));
imshow(gray_);
COM_=serial('COM7','BaudRate',9600);
COM_.InputBufferSize=1;
fopen(COM_)
sampled_img=zeros(255,255,'uint8');

for i=1:rows
    for j=1:columns
        fwrite(COM_,gray_(i,j));
        
    end
   disp(i);
end

while(1)
    for i=1:127
        for j=1:127
            
            Input1=fread(COM_);
            sampled_img(i,j)=Input1;
        end
        disp(i);
    end
    if(i==127 & j==127)
        break;
    end
end
subplot(1,2,1);  
imshow(gray_);
subplot(1,2,2);
imshow(sampled_img);



disp(sampled_img);
%ERROR CALCULATION

%MATLAB DOWNSAMPLED IMAGE
start_addr=[2 2];
addr=start_addr;
cal_pix=0;
Matlab_sampled_img=zeros(255,255,'double');
    
while(1)
    for i=1:127
        for j=1:127
            addr=[start_addr(1)+(j-1)*2 start_addr(2)+(i-1)*2];
            a11=[addr(1)-1 addr(2)-1];
            gray_(a11(2), a11(1));
            a12=[addr(1) addr(2)-1];
            gray_(a12(2), a12(1));
            a13=[addr(1)+1 addr(2)-1];
            gray_(a13(2), a13(1));
            a21=[addr(1)-1 addr(2)];
            gray_(a21(2), a21(1));
            a23=[addr(1)+1 addr(2)];
            gray_(a23(2), a23(1));
            a31=[addr(1)-1 addr(2)+1];
            gray_(a31(2), a31(1));
            a32=[addr(1) addr(2)+1];
            gray_(a32(2), a32(1));
            a33=[addr(1)+1 addr(2)+1];
            gray_(a33(2), a33(1));
            gray_(addr(2),addr(1));
            Matlab_sampled_img(i,j)=floor(((double(gray_(a11(2), a11(1)))+double(gray_(a13(2), a13(1)))+double(gray_(a31(2), a31(1)))+double(gray_(a33(2), a33(1))))+2*(double(gray_(a12(2), a12(1)))+double(gray_(a21(2), a21(1)))+double(gray_(a23(2), a23(1)))+double(gray_(a32(2), a32(1))))+4*double(gray_(addr(2),addr(1))))/16);
            
        end
        disp(i);
    end
    if(i==127 & j==127)
        break;
    end
end
error=0;
while(1)
    for i=1:127
        for j=1:127
            if((uint8(Matlab_sampled_img(i,j))-sampled_img(i,j))~=0)
                error=error+1
            end
        end
    end
   if(i==127 & j==127)
        break;
    end
end 
error=error*100/(127*127)
fclose(COM_);
delete(COM_);
