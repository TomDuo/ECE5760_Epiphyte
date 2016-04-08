clear;
buffer = csvread('buffer.csv');

buffer_box = reshape(buffer,[640 480]);

imagesc(buffer_box');
colorbar;