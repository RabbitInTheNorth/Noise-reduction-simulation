clear all
load('simulation data.mat')

% Perform ASVD noise reduction
[JG,SVDN,num]=ASVD_N_R(XX)

%%  Perform ICEEMDAN noise reduction
x=JG;
Nstd = 0.2;
NR = 100;
MaxIter = 1000;
SNRFlag=2;  
% Plot IMFs
[modes,its]=iceemdan(x,Nstd,NR,MaxIter,SNRFlag)
ecg=x;
t=1:length(ecg);
[a b]=size(modes);
figure;
subplot(a+1,1,1);
plot(t,ecg);% the ECG signal is in the first row of the subplot
ylabel('original signal')
%set(gca,'xtick',[])
title('ICEEMDAN')
axis tight;
 
for i=2:a
    subplot(a+1,1,i);
    plot(t,modes(i-1,:));
    ylabel (['IMF ' num2str(i-1)]);
    %set(gca,'xtick',[])
    xlim([1 length(ecg)])
end
 
subplot(a+1,1,a+1)
plot(t,modes(a,:))
ylabel('res')
xlim([1 length(ecg)])
xlabel('Sample points')

%% Select effective IMFs
s1=JG;
[a,b]=size(modes);
for i=1:a
  s2=modes(i,:);  
  rs(i,1)=corr(s1',s2','type','Spearman');  %Spearman correlation coefficient
end


imfcg=modes(1,:)+modes(2,:)+modes(3,:)+modes(4,:);

%% Plot result
plot(X0)
hold on
plot(imfcg)
legend("pure signal","ASVD-ICEEMDAN")




