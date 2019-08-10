function result = fcm(im)
I=im;
%im=rgb2gray(im);
im=imresize(im,[512 512]);
%figure(1), imshow(im,[]), title('input image');
Length=512*512;
a=1;
b=1;
c=1;

R=reshape(im, [1 Length]);
O = zeros(1, Length);
clusters=3;

j=im;
%mask size 5 x 5
N = 5;
%to retain original size of image even after filtering
im_pad = padarray(j,[floor(N/2) floor(N/2)]);

%sorting elements to get median
%im_col = rearranged matrix with 2D as in im_pad
im_col = im2col(im_pad,[N N],'sliding');

%sorts each column of im_pad in ascending order still retains 2D
sorted_cols = sort(im_col,1);

%finds median and returns a row martix containing medians for all columns of the input
med_vector = sorted_cols(floor(N*N/2)+1,:);

%converting result to matrix form to get the MEDIAN FILTERED image
out1 = col2im(med_vector,[N N],size(im_pad),'sliding');
%figure(2)
 %imshow(out1), title('median filtered image');
 
 K=[85, 170, 255];
 
% miniv = min(min(im));
% maxiv = max(max(im));
% range = maxiv-miniv;
% stepvar = range/clusters;
% incrval = stepvar;
% for i = 1:clusters
% K(i)= incrval;
% incrval = incrval + stepvar;
% end
 
cluster1=zeros(Length,1);
cluster2=zeros(Length,1);
cluster3=zeros(Length,1);

mean1=K(1);
mean2=K(2);
mean3=K(3);

update1=0;
update2=0;
update3=0;

while ((mean1 ~= update1) || (mean2 ~= update2) || (mean3 ~= update3))

a=1; b=1; c=1;    
    
mean1=update1;
mean2=update2;
mean3=update3; 
   
    
for i=1:Length
for j=1:clusters
temp = R(i);
diff(j)= abs(temp-K(j));
end

minimum=min(diff);

if minimum==diff(1)
    place=1;
elseif minimum==diff(2)
    place=2;
else
    place=3;
end

if (place==1)
cluster1(i) = R(i);
a=a+1;

O(i)=0;

end

if (place==2)
cluster2(i) = R(i);
b=b+1;
O(i)=128;

end

if (place==3)
cluster3(i)= R(i);
c=c+1;

O(i)=255;

end

end

%UPDATE CENTROIDS
m=0;
for x=1:(i-1)
    m=m+cluster1(x);
end    
m=m/(a-1);

update1=m;

m=0;
for x=1:(i-1)
    m=m+cluster2(x);
end    
m=m/(b-1);

update2=m;


m=0;
for x=1:(i-1)
    m=m+cluster3(x);
end    
m=m/(c-1);
update3=m;
% 
% K(1)=update1;
% K(2)=update2;
% K(3)=update3;

end

Op=reshape(O, [512 512]);
%imwrite(Op, 'FCMoutput.pgm');
%figure(3),imshow(uint8(Op));

result = (uint8(Op));
end
