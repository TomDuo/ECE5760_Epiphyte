clear all
figure(1); clf;

termination = 100;
x = linspace(-1.45, -1.3, 640); %[-2,1]
y = linspace(-0.07, 0.07, 480); %[-1,1]
x_index = 1:length(x) ;
y_index = 1:length(y) ;
img = zeros(length(y),length(x));


for k=x_index
    for j=y_index
        z = 0;
        n = 0;
        c = x(k)+ y(j)*i ;%complex number
        while (abs(z)<2 && n<termination)
            zsqr = z^2;
            zsqr = sign(real(zsqr))*min(3,abs(real(zsqr))) + ...
                i*min(3,abs(imag(zsqr)))*sign(imag(zsqr));
            z = z^2 + c;
            z = sign(real(z))*min(3,abs(real(z))) + ...
                i*min(3,abs(imag(z)))*sign(imag(z));
            n = n + 1;
        end
        img(j,k) = fix(log2(n));
    end
end

imagesc(img)
colormap(summer)
colorbar
