clear;
clc;
for n=0:159
fprintf('(1<<%i): begin\noR <= R[%i];\noG <= G[%i];\noB <= B[%i];\nend\n\n',n,n,n,n);
end
    
fprintf('default: begin\noR <= 8''d0;oG <= 8''d0;\noB <= 8''d0;\nend\n\n');