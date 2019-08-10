fCount=30; %number of images
fIndex = 1;
featuresmat = zeros(fCount, 4);    % 30x4 matrix of extracted features
type = zeros(fCount, 1);           % array to store type of image ('T' for tumour, 'N' for non-tumour)


type = ['T'; 'T'; 'T'; 'T'; 'T'; 'T'; 'T'; 'T'; 'N'; 'N'; 'N'; 'N'; 'N'; 'N'; 'T'; 'T'; 'T'; 'N'; 'N'; 'T'; 'T'; 'N'; 'N'; 'T'; 'T'; 'T'; 'N'; 'N'; 'N'; 'N'];
%type = {'T'; 'T'; 'T'; 'T'; 'T'; 'T'; 'T'; 'T'; 'N'}; % 'N'; 'N'; 'N'; 'N'; 'N'};

for fIndex= 1:fCount                              
    fIndex
    v = CheckImage(fIndex);                    %returns v- array of 4 extracted features
    
    for i=1:4
      featuresmat(fIndex,i)=v(1,i);            %copy the values to the matrix
    end
    
end


b = max(featuresmat);
c = min(featuresmat);

 for i=1:4

     for j=1:fCount
 					      %normalizing values of the feature matrix: (data-min)/max
     data = featuresmat(j,i);
     data = data - c(1,i); 
     data = data / b(1,i);            
     featuresmat(j,i)=data;

     end

 end

 C = num2cell(type);
 save('traindata.mat', 'featuresmat', 'C');   %save training dataset
 
% colNames={'a', 'b', 'c', 'd', 'e'};
 
% tb = array2table(featuresmat, 'VariableNames', colNames);
% Mdl = fitcsvm(tb,e);
 
%Md1 = fitcsvm(featuresmat, type);     

%SVMModel = fitcsvm(featuresmat, type);

