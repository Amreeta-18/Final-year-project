I = imread('mri4.jpg');
I=imresize(I,[512 512]);

%I = rgb2gray(I);
figure(1), imshow(I);

% median filter
[row col]=size(I);
J=I;
for i=1:(row-2)
    for j=1:(col-2)
          B = I(i:i+2, j:j+2);
          for k=1:9
              for l=1:8-k
                 if (B(l)>B(l+1)) 
                     c=B(l);
                     B(l)=B(l+1);
                     B(l+1)=c;
                 end
              end
          end
          J(i+1,j+1)=B(5);
    end
end
   % imwrite(J, 'pic_med_2.pgm');
   % figure(2), imshow(uint8(J)); 

% Initializing histograms
H = zeros(256);
H1 = zeros(256);
H2 = zeros(256);

% Calculating histogram
[l, w] = size(I);
for r = 1:l
    for c = 1:w
        index = I(r, c);
        index = index + 1;
        H(index) = H(index) + 1;
    end
end

% Displaying histogram
%figure;
%hist = bar(0:255, H, 'histc');

% Thresholding
q = zeros(255);
q(1) = H(1) / (l * w); %cumulative prob
n = zeros(255);
u = zeros(255);
P = 0; %probability
max = 0;
index = 0; index1=0 ; index2=0;


%initializing threshold value
sum = 0;
for j = 1:256
    sum = sum + j * H(j);
end
sum = sum / (l * w);

for i = 1:255
%     find sigma b^2 for each
%     pick the maximum value and use the corresponding i
%     if (sigma b^2 > th; th = sigb^2
    P = H(i + 1) / (w); %probability
    q(i + 1) = P + q(i); 
    n(i + 1) = ((i + 1) * P) / q(i + 1) + q(i) * n(i) / q(i + 1); 
    u(i + 1) = (sum - q(i + 1) * n(i + 1)) / (1 - q(i + 1)); %mean
    s1 = q(i + 1) * (1 - q(i + 1)) * (n(i + 1) - u(i + 1)); %variance
    s = s1 ^ 2;    %maximize inter class variance
    if (s > max)
        max = s;
        index = i;
    end
end
 th = index
% I2 = zeros(size(I));
% I2 (find(I>=th)) = 255;
% I2 (find(I<th)) = 0;
% figure;
% imshow(I2); 


it=0;
while (it < 100)
    
count1=1;
count2=1;

it=it+1;

[r1, c1] = size(I);
for r = 1:r1
    for c = 1:c1
        if (I(r, c) >= th)
            F(count1)= I(r,c);
            count1=count1+1;
        end
        if (I(r,c)< th)
            S(count2)= I(r,c);
            count2=count2+1;
        end  
        
    end
end

% Calculating histogram for each F & S
[l, w1] = size(F);
for r = 1:l
    for c = 1:w1
        index1 = F(r, c);
        index1 = index1 + 1;
        H1(index1) = H1(index1) + 1;
    end
end


[l, w2] = size(S);
for r = 1:l
    for c = 1:w2
        index2 = S(r, c);
        index2 = index2 + 1;
        H2(index2) = H2(index2) + 1;
    end
end

%calculate new thresholds
sum1 = 0;
for j = 1:256
    sum1 = sum1 + j * H1(j);
end
sum1 = sum1 / (w1);

sum2 = 0;
for j = 1:256
    sum2 = sum2 + j * H2(j);
end
sum2 = sum2 / (w2);

T = (sum1+sum2)/2;
diff = T - th;
th=T;

end

th = index;
I3 = zeros(size(I));
I3 (find(I>=th)) = 255;
I3 (find(I<th)) = 0;
%figure (2), imshow(I3); 


level = graythresh(I);
BW = imbinarize(I,level);
figure (2), imshow(BW);
imwrite(BW, 'tsmo_out.pgm');