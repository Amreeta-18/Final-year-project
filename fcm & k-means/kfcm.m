clear;
close all;

im=imread('Brainimage.pgm');
im=imresize(im,[512 512]);
figure(1), imshow(im,[]), title('input image');
I=im;

Length=512*512;
vec = reshape(im, [1 Length]);
vec=double(vec);

cluster_n = 3;
centre = zeros(3,1);
centre_update = zeros(3,1);
diff = [1, 1, 1];
centre = [85, 175, 255];
centre=double(centre);

t_max=100;
e = 0.1;
m=2;
sum = 0;
mem = zeros(Length, 3);

t=1;
while((diff(1) > 0.01) && (diff(2) > 0.01) && (diff(3) > 0.01))
       
    %membership loop!!
    
    for i=1:Length
        
        data = vec(i);
        
        sum = 0;
        
        %calculate sum
        for j=1:cluster_n
            
           % data;
           % centre(j);
            a = K(data, centre(j));
            b = (1-a)^(-1); % -1/(m-1) = -1
            sum = sum+b;
            
        end
        
        %membership function
        for j=1:cluster_n
            
             a = K(data, centre(j));
             b = (1-a)^(-1);
             if a==1
                 mem(i,j)=1;
             else             
                 mem(i, j) = b/sum;
             end
        end
        
        
            
      %  mx = max(max(mem(i,1), mem(i,2)), mem(i,3));
        
       % for j=1:cluster_n
       %      if mx==mem(i,j)
       
       %update centroids       
        
    end
        
   
    %centroid loop!!
    
     for j=1:cluster_n
         
         num=0; den=0;
         num=double(num); den=double(den);
         
         
         
         for i=1:Length
             
            % x = mem(i,j)*K(vec(i), centre(j));
%           
            num = num + (mem(i,j)*K(vec(i),centre(j))*vec(i));   
            den = den + (mem(i,j)*K(vec(i), centre(j)));  
            
        end 
%         
        centre_update(j)= double(num)/double(den);
        diff(j) = abs(centre(j) - centre_update(j));
%                         
     end
     
         
      for j=1:cluster_n
             centre(j)=centre_update(j);
      end
    
end
        
        
        
   [row, col]=size(im);
   cluster_id = zeros(row,col);
   for i=1:row
       for j=1:col

           pix=double(im(i,j));
           diff(1)=abs(pix-centre(1));
           diff(2)=abs(pix-centre(2));
           diff(3)=abs(pix-centre(3));
           
           mn = min(diff);
           
         if mn==diff(1)
            im(i,j)= 0;
             cluster_id(i,j) = 1;
         end
         if mn==diff(2)
             im(i,j)=150;
              cluster_id(i,j) = 2;
         end
         if mn==diff(3)
             im(i,j)=255;
              cluster_id(i,j) = 3;
         end
       end
   end
            
            
figure(2), imshow(uint8(im));
im=uint8(im);
imwrite(im,'KFCM_output2.pgm');

 %validity index
n=3;
 s1=0;
 for k=1:n      %clusters = no of cluster centres
     s=0;
     s = double(s);
     for i=1:512
         for j=1:512
              if (cluster_id(i,j)==k) 	
 				     diff = abs( I(i,j) - centre(k));
 				     diff= double(diff*diff);
 				     s=s+diff;
              end

         end
     end              
                 
                 s1=double(s1+s);  
 end

intra=(s1/(1.0*512*512));
intra;
	min=99999;
	for i=1:n-1
		for j=i+1:n
		
			diff=abs(centre(i)-centre(j));
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
	VI= (mul*intra/inter)
    
