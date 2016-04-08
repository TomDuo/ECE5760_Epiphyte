function n = mProc(x,y,termination)
    z = 0;
    n = 0;
    c = x+ y*i ;%complex number
    while (abs(z)<2 && n<termination)
            zsqr = z^2;
            zsqr = sign(real(zsqr))*min(3,abs(real(zsqr))) + ...
                i*min(3,abs(imag(zsqr)))*sign(imag(zsqr));
            z = z^2 + c;
            z = sign(real(z))*min(3,abs(real(z))) + ...
                i*min(3,abs(imag(z)))*sign(imag(z));
            n = n + 1;

    end
end