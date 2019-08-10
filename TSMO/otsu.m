im=imread('img016p.bmp');
%figure,imagesc(im);
%colormap(gray);

%displays the size of image
disp(size(im));

%converts image to double
im_double=im2double(im);

%removes noise by applying median filter
im_med=medfilt2(im);

% smoothing filter matrix
filtr=[1 1 1 1 1 1 1 ;
       0 0 0 0 0 0 0];
   
   %texture filter is applied to determine the texture image
  im_text=rangefilt(im_double);
  %applying smoothing filter on the texture image
  im_text=imfilter(im_text,filtr);
  imshow(im_text);
  
    %takes coordinates of tumor region
  [row,col]=ginput();
tumor_region=[row,col];
%determine the texture values of the tumor region
val_tumor=impixel(im_text,tumor_region(:,1),tumor_region(:,2));

disp('skull');
imshow(im_text);
%take coordinates of the skull region
[rols,cols]=ginput();
skull_region=[rols,cols];

%determine the texture values of the skull region
val_skull=impixel(im_double,skull_region(:,1),skull_region(:,2));
disp(val_skull(:,1));

%target variable is a vector which divides into two classes :0 represents
%skull region and 1 represents tumor region
target_variable=[zeros(numel(val_skull(:,1)),1); ones(numel(val_tumor(:,1)),1)];

%making the dimensions of the target variable and tumor region same
val_tumor=[val_tumor(:,1);zeros(length(target_variable) - length(val_tumor),1)];

%compute cross correlation
correlation=xcorr2(target_variable,val_tumor);
disp(max(correlation(:)));


%Otsu thresholding

%imtophat computes morphological opening using the structuring element as
%specified and subtracts the result from the original image.
im_thresh=imtophat(im_med,strel('disk',40));
imshow(im_thresh);
pause(2);
%improves the contrast of the image
im_adjust=imadjust(im_thresh);
imshow(im_adjust);
pause(2);
%determines the threshold value to perform segmentation
level=graythresh(im_adjust);
%segments the image into two classes: 0 if less than level and 1 if greater
%or equal to level
BW=imbinarize(im_adjust,level);
imshow(BW);
%performs morphological erosion
strel_erode=strel('disk',3);
im_erode=imerode(BW,strel_erode);
imshow(im_erode);
title('Otsu thresholding');
pause(5);
