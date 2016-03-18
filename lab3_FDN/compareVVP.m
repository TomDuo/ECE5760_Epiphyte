clear;

out = csvread('single.csv');

fs = 12000;
sound(out,fs);
audiowrite('sound.wav',out,fs);

PSD = pwelch(out);
freq = linspace(0,fs/2,length(PSD));

[pks,locs] = findpeaks(PSD,'MinPeakProminence',max(PSD)/2);
PSD_db = 10*log10(PSD);
clf;
hold on;
plot(1:length(PSD),PSD_db);

for m=1:4
    for n=1:4
        plot([ locs(1)*sqrt(m^2+n^2)/sqrt(2), locs(1)*sqrt(m^2+n^2)/sqrt(2)] , [-1000,1000], 'r' );
    end
end
hold off;
xlim([0,100]);
ylim([min(PSD_db),max(PSD_db)]);
%pks = pks ./ pks(1)