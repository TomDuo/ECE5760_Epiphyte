function n = mProc(x,y,termination)
    z = 0;
    n = 0;
    c = x+ y*i ;%complex number
    while (abs(z)<2 && n<termination)
        z = z^2 + c;
        n = n + 1;
    end
end