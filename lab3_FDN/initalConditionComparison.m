xSize=10;
ySize=10;
n = 2*xSize ;
clc;
uHit = zeros(n,n); %input strike
% boundary condition -1.0<gain<1.0
% 1.0 is completely free edge
% 0.0 is clamped edge
boundaryGain = 0;

%sets the amplitude of the stick strike 
ampIn = .1;
%sets the position of the stick strike: 0<pos<n
x_mid = n/2;
y_mid = n/2;
%sets width of the gaussian strike input -- see figure 1
alpha = .1 ;
%compute the gaussian strike amplitude
for i=2:n-1
    for j=2:n-1
        uHit(i,j) = ampIn*exp(-alpha*(((i-1)-x_mid)^2+((j-1)-y_mid)^2));
    end
end
%enforce boundary conditions
uHit(1,:) = boundaryGain * uHit(2,:);
uHit(n,:) = boundaryGain * uHit(n-1,:);
uHit(:,1) = boundaryGain * uHit(:,2);
uHit(:,n) = boundaryGain * uHit(:,n-1);


figure(1);clf;
mh = mesh(uHit);
title('initial displacement')
set(gca, 'zlim', [-0.5,0.5])


uPatch = zeros(xSize,ySize);
uPatchBinary = int64(zeros(xSize,ySize));

fprintf('wire [17:0] gaussian [0:xSize-1][0:ySize-1];\n'); 
for x=0:xSize-1
    for y=0:ySize-1
            if (x == 0 || y ==0)
                uPatch(x+1,y+1) = 0;
            else
               uPatch(x+1,y+1) = ampIn*exp(-alpha*(((xSize-x)-1)*((xSize-x)-1) + ((ySize-y)-1)*((ySize-y)-1)));
            end
               uPatchBinary(x+1,y+1) = int64(uPatch(x+1,y+1)*(65536.0));
               fprintf('assign gaussian[%i][%i] = 18''h%x;\n',x,y,uPatchBinary(x+1,y+1));
    end
end

uTiled = [uPatch fliplr(uPatch);
                flipud(uPatch) fliplr(flipud(uPatch))];
       figure(2);clf;
mh = mesh(uTiled);
title('tiled displacement')
set(gca, 'zlim', [-0.5,0.5])
pause(1);
close all;


