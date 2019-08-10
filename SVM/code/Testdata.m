fCount=4; 
fIndex = 1;
featuresmat = zeros(fCount, 4);  %4x4 matrix of extracted features

for fIndex= 1:fCount
    fIndex
    v = CheckImage1(fIndex);
    
    for i=1:4
      featuresmat(fIndex,i)=v(1,i);
    end
    
end

b = max(featuresmat);
c = min(featuresmat);

 for i=1:4

     for j=1:fCount
 
     data = featuresmat(j,i);
     data = data - c(1,i);
     data = data / b(1,i);
     featuresmat(j,i)=data;

     end

 end

save('testdata.mat', 'featuresmat');

