%% Low CP-rank approximation from Linear Measurements

%addpath(genpath('../../tensorlab/'));


close all
clc
clear

%% Parameters
rr = 2;										% CP-rank
dd = 3;										% Order of tensor
Nvec = [10 10 10];							% d-dimension vector with sizes
MMRates = [0.3 0.5 0.7 0.9];				% Measurement rates (M/N^d) for equal N
MMvec = round(MMRates.*prod(Nvec));			% Number of measurements
sig = 0;									% std for noise
saveBoo = 1;								% Bool for saving figures
opts.numIts = 200;							% Number of iterations
opts.mu = .5;

%% Construct tensor
XX = zeros(Nvec);
for jj = 1:rr
	xx = cell(dd,1);
	for ii = 1:dd
		xx{ii} = randn(Nvec(ii), 1);
	end
	XX = XX + buildTens(xx);
end

%% Set up figure
figure
set(0, 'defaultlinelinewidth', 2)
set(0,'defaultAxesFontSize', 14)
markers = {'--+', '-.*', ':^', '-o'};

%% For each value of M
for jj=1:length(MMvec)

	%% Number of measurements
	MM = MMvec(jj)

	%% Linear Measurements
	AA = randn(MM, prod(Nvec))*1/sqrt(MM);
	zz = randn(MM,1);
	zz = zz./norm(zz)*sig;
	yy = AA*vec(XX) + zz;

	%% Main 
	[Xhat, out] = cpTIHT(yy, AA, rr, XX, opts);

	%% Plot results
	semilogy(out.err, markers{jj}, 'MarkerIndices',1:opts.numIts/10:opts.numIts, 'DisplayName', ['M/N^3 = ' num2str(MMRates(jj))])
	hold on
end

%% Finish plots
legend('show')
xlabel('Iterations')
ylabel('Approx. Error')

%% Save plot
if(saveBoo)
    set(gcf,'WindowStyle','normal'); 
    set(gcf,'PaperPositionMode','Auto');
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 6 5]); 
    fname = sprintf('%s_%drr_%ddd_%.2fsig_%dnd', mfilename(pwd), rr, dd, sig, prod(Nvec));
    saveFigure(strcat('figs/', fname ,'.fig'))
    saveas(gcf, strcat('figs/', fname ,'.png'))
    save(strcat('data/',fname, '.mat'));
end
