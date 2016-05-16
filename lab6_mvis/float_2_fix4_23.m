
function y = decTo4_23fix(x)
assert(abs(x) < 8,'FUK');

x = x*(2^23);

x = int32(round(x));
y = bitand(x,hex2dec('7FFFFFF'));
end