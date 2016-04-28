function dec = fix2_16todec(bin)
dec = 0;
for i = 1:18
    dec = dec + bin(i)*2^(2-i);
end
end
