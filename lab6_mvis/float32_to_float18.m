function [y,z,shex,exphex,manthex] = float32_to_float18(x)
    if abs(x) >= 2^(127)
        y = -1;
    else if(x==0)
        y = 0;
    else
        if(sign(x)==1)
            sign_bit = 0;
        else
            sign_bit = 1;
        end
        x=abs(x);
        exponent=ceil(log2(x+.0000001));
        mantissa =x/(2^exponent);
        exponent = exponent +128;
        mantissa=round(mantissa*2^9);
        if mantissa == 512
            mantissa = 511
        end
        y = bitor(bitor(bitsll(sign_bit,17),bitsll(exponent,9)),mantissa);
        [z,shex,exphex,manthex] = float18_to_float32(y);
         end
end