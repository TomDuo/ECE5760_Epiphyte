
function y = float_2_fix2_16(x)
assert(abs(x) < 8,'FUK');

x = x*(2^16);

x = int32(round(x));
y = bitand(x,hex2dec('3FFFF'));
end