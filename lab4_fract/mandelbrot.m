clear all
figure(1); clf;

termination = 1000;
%x = linspace(-2,1,640);
%y = linspace(-1,1,480);
x=linspace(-0.758 ,-.75,640); 
y=linspace(0.05,0.06,480);

x_index = 1:length(x) ;
y_index = 1:length(y) ;
img = zeros(length(y),length(x));


for k=x_index
    for j=y_index
        z = 0;
        n = 0;
        c = x(k)+ y(j)*i ;%complex number
        while (abs(z)<2 && n<termination)
            z = z^2 + c;
            n = n + 1;
        end
        img(j,k) = n;
    end
end

imagesc(img)
colormap(summer)
colorbar();
