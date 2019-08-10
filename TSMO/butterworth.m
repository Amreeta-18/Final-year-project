f=imread('mri.png'); 
[M N]=size(f);
figure(1),imshow(f);
% compute fft and display its spectra
F=fft2(double(f));
figure(2),imshow(abs(fftshift(F)/256));

%compute Ideal Low Pass Filter
u0 = 100; % set cut off frequency
u=0:(M-1);
v=0:(N-1);
idx=find(u>M/2);
u(idx)=u(idx)-M;
idy=find(v>N/2);
v(idy)=v(idy)-N;
[V,U]=meshgrid(v,u);
for i = 1: M
for j = 1:N
    
%Apply a 2nd order Butterworth
UVw = double((U(i,j)*U(i,j) + V(i,j)*V(i,j))/(u0*u0));
H(i,j) = 1/(1 + UVw*UVw);
end
end
figure(3),imshow(fftshift(H));
G=H.*F;
g=real(ifft2(double(G)));

% Show Result
figure(4),imshow(uint8(g));