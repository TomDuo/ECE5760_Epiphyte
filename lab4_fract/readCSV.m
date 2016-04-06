clear;
buffer = csvread('buffer.csv');

buffer_box = reshape(buffer,[480 640]);

imshow(buffer_box);