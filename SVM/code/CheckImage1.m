function v = CheckImage(idx)
fileName = sprintf('./Images/Test data/t%d.tif', idx);
I = imread(fileName);
%imshow(image);
a=1;

[row col]=size(I);
J=I;

%preprocessing-1 median filter
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
  %  figure(1), imshow(I);
  %  figure(2), imshow(J);
        
  J = fcm(J);
  
  e1 = featurext(J);
stats = graycoprops(e1);

v = [stats.Contrast, stats.Correlation, stats.Energy, stats.Homogeneity];

end