clear;

width = 800;
height = 600;
A = zeros(height,width);
for n=1:2:width
   A(1:height,n) = 255; 
end
imshow(A);
imwrite(A,'pattern.png');