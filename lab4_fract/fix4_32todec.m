function dec = fix4_32todec(bin)
dec = 0;
for i = 1:36
    dec = dec + bin(i)*2^(-33+i);
end
end
