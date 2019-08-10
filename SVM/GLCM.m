I=imread('cd2.tif');
e1=imresize(I,[128,128]);
r1 = graycomatrix(e1);
disp(r1);
t1=imhist(e1);
figure,imshow(e1);
stats = graycoprops(e1)