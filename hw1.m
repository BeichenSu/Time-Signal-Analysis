clear all; close all; clc;
load Testdata
L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; 



[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(k,k,k);
Ufave = zeros(n,n,n);
% Reshape, fourier transform, add up in frequency domain 
% to cancel the white noise
for j=1:20
Un(:,:,:)=reshape(Undata(j,:),n,n,n);
Unf = fftn(Un);
Ufave(:,:,:) = Ufave + abs(Unf(:,:,:));
end

Ufave = Ufave/20;

% Find out the center frequency
Ufave = reshape(Ufave,n^3,1);
[m,I] = max(abs(Ufave));
[a,b,c] = ind2sub([n,n,n], I);

% Represent the center frequency in fourier domain
Ka = Kx(a,b,c);
Kb = Ky(a,b,c);
Kc = Kz(a,b,c);

% Build gaussian filter
width = 1;
Filter = exp(-width*((Kx - Ka).^2+(Ky - Kb).^2+(Kz - Kc).^2));
x = [];
y = [];
z = [];
% Bilter the noise out and save the position
% of marble at each snap shot
for j = 1:20
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    Unf = fftn(Un);
    Uf = Unf.*Filter;
    U = ifftn(Uf);
    U = reshape(U,n^3,1);
    [m,I] = max(U);
    [a,b,c] = ind2sub([n,n,n], I);
    x(j) = X(a,b,c);
    y(j) = Y(a,b,c);
    z(j) = Z(a,b,c);
    
end
% Plot the path of marble
grid on;
plot3(x,y,z,'b--o ');
hold on;
grid on;

plot3(x,y,z)
title('Trajectory of marble')
PositionOfMarble = [x; y ;z];
% Last location
lastOne = PositionOfMarble(:,20);