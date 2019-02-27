[x fs]=audioread('violin.wav');
%hps
tic
for i=1:round(length(x)/1000)-1
    
y=abs(fft(x(((i-1)*1000+1):((i-1)*1000+1000))));

y2=downsample(y,2);
y3=downsample(y,3);
y4=downsample(y,4);
for j=1:length(y4)
   prod(j) =   y(j)  .* y2(j) .* y3(j) .* y4(j);
end
[m n]=findpeaks(abs(prod), 'SORTSTR', 'descend');
k=( (n(1) / 1000) * fs ); 
hps(i)=k;
end
hpst=toc
%% chps
tic
for i=1:round(length(x)/1000)-1
    
y=abs(fft(x(((i-1)*1000+1):((i-1)*1000+1000))));
z=log(abs(y));
c=fft(z);
c2=downsample(c,2);
c3=downsample(c,3);
c4=downsample(c,4);
for j=1:length(c4)
   prod(j) =   c(j)  .* c2(j) .* c3(j) .* c4(j);
end
[m n]=findpeaks(abs(prod), 'SORTSTR', 'descend');
chps(i)=1/n(1);

end
chps=chps*fs;
chpst=toc;
%% ml
tic
[time, f0] = max_likelihood(x',fs);
mlt=toc
%%
gt=resample(pitch_gt,275,1243);
ml=resample(f0,275,length(f0));

for i=1:length(hps)
   if hps(i)>650
       hps(i)=0;
   end
   if chps(i)>650
       chps(i)=0;
   end
   if ml(i)>650
       ml(i)=0;
   end
end
%%
plot(gt)
hold on
plot(hps)
hold on
plot(chps)
hold on
plot(ml)
legend('gt','hps','chps','ml')
xlabel('frame')
ylabel('pitch (hz)')
title('postprocessed results')