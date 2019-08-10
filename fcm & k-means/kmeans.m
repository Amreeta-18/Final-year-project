clear;
close all;
im = imread('mri4.jpg');
I=im;
im=imresize(im,[512 512]);
I2=im;
p=1;

input_image=im;
org_img=im;
I1=im;
im=im2double(im);
j=im;

imshow(im,[]), title('input image');

N = 5;
im_pad = padarray(j,[floor(N/2) floor(N/2)]);

im_col = im2col(im_pad,[N N],'sliding');
sorted_cols = sort(im_col,1);
med_vector = sorted_cols(floor(N*N/2)+1,:);

out1 = col2im(med_vector,[N N],size(im_pad),'sliding');
%figure(2)
% imshow(out1), title('median filtered image');

max_val = max(max(im));
z = max_val/255;
im = im./z;
 
[rows, columns, numberOfColorBands] = size(im);

binaryImage = im > 20;
% to remove noise
binaryImage = bwareaopen(binaryImage, 10);
%figure(3), imshow(binaryImage,[]);

finalImage = im;
finalImage(~binaryImage) = 0;
%figure(4), imshow(finalImage, []);


%%Kmeans

  out2=finalImage;

max_val=max(max(out2));
out3=out2.*(255/max_val);
im1=uint8(out3);

%choose k
k=3;

%histogram calculation
img_hist = zeros(256,1);
hist_value = zeros(256,1);

for i=1:256
    img_hist(i)=sum(sum(im1==(i-1)));
end;

for i=1:256
    hist_value(i)=i-1;
end;

%cluster initialization
cluster = zeros(k,1);
cluster_count = zeros(k,1);
%select random centroids
for i=1:k
    cluster(i)=uint8(rand*205);
end;
%cluster(i)=randi(255);

old = zeros(k,1);

%termination condition

while (sum(sum(abs(old-cluster))) >k)
    old = cluster;
    closest_cluster = zeros(256,1);
    
    min_distance = abs(hist_value-cluster(1));
    
    for i=2:k
        min_distance =min(min_distance,  abs(hist_value-cluster(i)));
    end;
    
   for i=1:k
        closest_cluster(min_distance==(abs(hist_value-cluster(i)))) = i;
    end;
    
   for i=1:k
        cluster_count(i) = sum(img_hist .*(closest_cluster==i));
    end;
    
    for i=1:k
        if (cluster_count(i) == 0)
            cluster(i) = uint8(rand*255);
        else
            cluster(i) = uint8(sum(img_hist(closest_cluster==i).*hist_value(closest_cluster==i))/cluster_count(i));
        end;
    end;
    
end;
imresult=uint8(zeros(size(im1)));

cluster = sort(cluster);

for i=1:256
    imresult(im1==(i-1))=cluster(closest_cluster(i));
end;


% figure(5), imshow(imresult);
%  title('k means output');
%  imwrite(imresult, 'Kmeansoutput.pgm');
 
 cluster_id = zeros(512,512);
 
 for i=1:512
     for j=1:512
         
         if imresult(i,j)==cluster(1)
             imresult(i,j)=255;
             cluster_id(i,j) = 1;
         elseif  imresult(i,j)==cluster(2)
              imresult(i,j)=0;
             cluster_id(i,j) = 2;
         elseif  imresult(i,j)==cluster(3)
              imresult(i,j)=186;
             cluster_id(i,j) = 3;
         end
         
     end
 end
 
 figure(5), imshow(imresult);
 title('k means output');
 imwrite(imresult, 'Kmeansoutput2.pgm');
 
 
 %validity index
n=3;
 s1=0;
 for k=1:n      %clusters = no of cluster centres
     s=0;
     s = double(s);
     for i=1:512
         for j=1:512
              if (cluster_id(i,j)==k) 	
 				     diff = abs( im1(i,j) - cluster(k));
 				     diff= double(diff*diff);
 				     s=s+diff;
              end

         end
     end              
                 
                 s1=double(s1+s);  
 end
 s1

intra=(s1/(1.0*512*512));
intra;
	min=99999;
	for i=1:n-1
		for j=i+1:n
		
			diff=abs(cluster(i)-cluster(j));
			if((diff*diff)<min)
			min=diff*diff;
            end
		%//printf("min = %.2f\n",min);
        end
    end
	inter=min;
	d=sqrt(2*3.14);
	e=((n-2)*(n-2))/2.0;
	N=(1/(1.0*d))*exp(-e);
	mul=(25*N)+1;
	VI= 1 + (mul*intra/inter)
    
	%printf("VI = %f\n",VI);