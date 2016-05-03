% read in the bitmaps
bitmap_names = {'head.bmp', 'arm1.bmp', 'arm2.bmp', 'torso.bmp','tux_arm_L.bmp',...
   'tux_arm_R.bmp','tux_legs.bmp','tux_torso.bmp', };

%% create mif file

for fname=bitmap_names
bitdepth=24;
x = imread(fname{1});

mifname = strrep(fname{1}, 'bmp', 'mif');
xSize = size(x);
xHeight = xSize(1);
xWidth = xSize(2);
xNColors = xSize(3);
depth = xHeight*xWidth;
dfv = 255;
fid = fopen(mifname,'w');
str = sprintf('DEPTH = %i;\nWIDTH = %i;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\n', depth, bitdepth);
fprintf(fid,str);
str = 'CONTENT\nBEGIN\n\n';
fprintf(fid,str);

col_idx=0;
row_idx=0;
%color_idx=0;
for linenum=1:depth
    %fprintf('%i %i %i\n', color_idx,col_idx,row_idx);
    color_pack = 65536*uint32(x(row_idx+1,col_idx+1,1)) + 256*uint32(x(row_idx+1,col_idx+1,2)) + uint32(x(row_idx+1,col_idx+1,3));
    disp([x(row_idx+1,col_idx+1,1),  x(row_idx+1,col_idx+1,2), x(row_idx+1,col_idx+1,3)])
    disp(color_pack);
    fprintf('%06X\n',color_pack);
    str = sprintf('%04X : %06X;\n',linenum-1, color_pack);
    fprintf(fid,str);
   % if(color_idx < xNColors-1)
   %     color_idx = color_idx + 1;
    if (col_idx < xWidth-1)
       % color_idx = 0;
        col_idx = col_idx+1;
    elseif (row_idx < xHeight-1)
       % color_idx = 0;
        col_idx=0;
        row_idx = row_idx+1;
    end
end
fprintf(fid,'\nEND;\n');
fclose(fid);
end;