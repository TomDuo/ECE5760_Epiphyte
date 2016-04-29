% read in the bitmaps

head = 'head.bmp';
arm_l = 'arm1.bmp';
arm_r = 'arm2.bmp';
body = 'torso.bmp';

xHead = imread(head);
xArm_L = imread(arm_l);
xArm_R = imread(arm_r);
xBody = imread(body);

x= xHead
size(x)
serial_bytes = reshape(x,1,numel(x));

%% create mif file
name = 'xHead';
bitdepth=24;

xSize = size(x);
xHeight = xSize(1);
xWidth = xSize(2);
xNColors = xSize(3);
depth = xHeight*xWidth;
dfv = 255;
fid = fopen(strcat(name,'.mif'),'w');
str = sprintf('DEPTH = %i;\nWIDTH = %i;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\n', depth, bitdepth);
fprintf(fid,str);
str = 'CONTENT\nBEGIN\n\n';
fprintf(fid,str);

col_idx=0;
row_idx=0;
%color_idx=0;
for linenum=1:depth
    fprintf('%i %i %i\n', color_idx,col_idx,row_idx);
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