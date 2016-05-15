function [y,shex,exphex,manthex] = float18_to_float32(x)
if ~(round(x)==x)
y = -1;
else
    x = uint64(x);
    
    sign_bit = bitand(bitsrl(x,17),hex2dec('01'));
    sign_bit = double(sign_bit);
    shex=dec2hex(sign_bit);
    exponent = bitand(bitsrl(x,9),hex2dec('FF'));
    exphex = dec2hex(exponent);
    exponent = double(exponent);
    %exponent = double(int8(exponent));
    mantissa = bitand(x,hex2dec('1FF'));
    manthex=dec2hex(mantissa);
    mantissa = double(mantissa);
    y = (1-2*sign_bit)*(2^(exponent-128))*(mantissa/(2^9));
end
end