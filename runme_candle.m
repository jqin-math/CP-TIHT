

close all
clc
clear




%% Parameters
rr = 15;						% CP-rank
dd = 3;						% Order of tensor


%% Construct tensor
display('Loading video tensor...');
load('candle_5_A.mat');
Kspatch = grayMat(21:end,56:115,1:5);
Kt50 = buildTens2(cpd(double(Kspatch),rr));
rr=2*rr;
XX = double(Kspatch);
figure

subplot(2,1,1)
imagesc(Kt50(:,:,1));
title('Original');
colormap gray;

subplot(2,1,2)
imagesc(Kspatch(:,:,1))
display('Press any key to continue...');
pause
Nvec = size(XX);			% d-dimension vector with sizes
Mrate = 0.8;
MM = round(Mrate*prod(Nvec));		% Number of measurements
sig = 0;					% std for noise
opts.numIts = 300;			% Number of iterations
opts.mu = 0.5;


%% Linear Measurements
AA = randn(MM, prod(Nvec))*1/sqrt(MM);
yy = AA*vec(XX) + randn(MM,1)*sig;

keyboard
%% Main 
[Xhat, out] = cpTIHT(yy, AA, rr, XX, opts);

%% Plot results
str = ['candle_m',num2str(Mrate*100), '_r', num2str(rr/2), '_n', num2str(size(XX,1))];

figure
semilogy(out.err(1:130)./frob(XX), 'Linewidth', 3)
hold on
xlabel('Iteration');
ylabel('Relative error');
title(['Distance from rank', num2str(rr/2), ': ', num2str(frob(XX - buildTens2(cpd(double(Kspatch),rr)))/frob(XX))]);

set(gca,'FontSize',16)
hold off
saveas(gcf,[str,'.png'])
saveas(gcf,[str,'.fig'])

figure

imagesc(flip(flip((XX(:,:,1)),1),1));
hold on
title('Original');
colormap gray;
set(gca,'FontSize',16)
hold off;
saveas(gcf,[str,'_orig.png'])
saveas(gcf,[str,'_orig.fig'])

figure

imagesc(flip(flip((Xhat(:,:,1)),1),1));
hold on
title('Reconstructed');
colormap gray;
set(gca,'FontSize',16)
hold off
saveas(gcf,[str,'_recon.png'])
saveas(gcf,[str,'_recon.fig'])
