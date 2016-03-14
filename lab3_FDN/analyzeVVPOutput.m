clear;

out = csvread('out.csv');

plot(out);

%sound(sin(2*pi*440.*linspace(0,1,8000)),8000);
%pause(1);
sound(out,8000);5