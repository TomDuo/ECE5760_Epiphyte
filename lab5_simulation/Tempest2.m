%%
clear;
img= imread('BSOD.jpg'); %y,x,rgb
bwimg = rgb2gray(img);
%bwimg = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15; 16 17 18 19 20];
bwimg_serial = reshape(bwimg.',[1 numel(bwimg)]);        %serialize image
bwimg_serial = double(bwimg_serial-127);
%bwimg_serial(1280*200+1:1280*201) = 0;
%y=bwimg_serial;
%For now assume fpixel=~78Mhz (true for 1280x1024)
nframes_max=6;

x = repmat(bwimg_serial,1,nframes_max);%concatenate with itself 5 times.

start_idx = randi(numel(bwimg_serial)); %randomize where we started recording
end_idx = numel(x) - randi(numel(bwimg_serial)); %and where we ended recording

x=x(start_idx:end_idx);
xht = hilbert(x);
Fsx = 1280*1024*60;

%xI = conv(x,x);
%xQ = conv(x,x);


frame_len_approx=1000*1000;
correlation_window_length = frame_len_approx*1.5; %We can't be sure how long window is, but we can have a good guess
%autoc  = xcorr(x);
autoc = cconv(x,fliplr(x));


[peaks,locs] = findpeaks(autoc,'MinPeakDistance',.8*frame_len_approx);%, 'MinPeakProminence', 1);


initial_lag = locs(1);
distances_between_peaks = diff(locs);
frame_length = median(distances_between_peaks);

A_lo =exp(-j*(2*pi/8*(0:length(x)-1)));
hd = Filt();
y = x.*A_lo;
y= filter(hd,y);
xspec = fftshift(fft(x));
xhtspec = fftshift(fft(xht));
lo_spec = fftshift(fft(A_lo));
yspec   = fftshift(fft(y));
clf;
%numel(bwimg_serial)/autoc_max_idx
subplot(3,2,1);
plot(abs(xspec));
title('Spectrum of transmitted baseband');
%plot(x);
%title('Transmitted signal');
subplot(3,2,2);
plot(autoc);
title('Circular Autocorrelation of received signal');
subplot(3,2,3);
plot(abs(xhtspec));
title('Spectrum of Hilbert Transformed baseband');
subplot(3,2,4);
plot(abs(lo_spec));
title('Spectrum of Local Oscillator');
subplot(3,2,5);
plot(abs(yspec));
title('Mixed Complex Baseband');


%%
y=x(1:1280*1024);
%reconstruct image from serial
W=1280;
H=1024;
y = reshape(y,[W,H]).';

hFig = figure('Toolbar','none', 'Menubar','none');
hIm = imshow(y,'InitialMagnification',100);
hSP = imscrollpanel(hFig,hIm);
%truesize