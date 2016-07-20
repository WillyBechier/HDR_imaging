function [square_ecg] = AnalyseSquare(Signal,Fs)

Ns=length(Signal);
Time = (1 : Ns)/Fs;

square_ecg=Signal.^2;

figure(1);
subplot(615)
plot(Time,[square_ecg(1:Ns-20) zeros(1,20)],'k');title('signal Square');

end

