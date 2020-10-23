%% Low CP-rank approximation from Linear Measurements

%addpath(genpath('../../tensorlab/'));


close all
clc
clear

%% Parameters
rrVec = 2:5;								% CP-rank
dd = 3;										% Order of tensor
Nvec = [10 10 10];							% d-dimension vector with sizes
MM = round(0.5.*prod(Nvec));				% Number of measurements
sig = 0.01;									% std for noise
saveBoo = 1;								% Bool for saving figures
opts.numIts = 100;							% Number of iterations
opts.mu = 0.5;

%% Set up figure
figure
set(0, 'defaultlinelinewidth', 2)
set(0,'defaultAxesFontSize', 14)
markers = {'--+', '-.*', ':^', '-o'};

%% For each value of r
for jj=1:length(rrVec)

	%% Number of measurements
	rr = rrVec(jj)

	%% Construct tensor
	XX = zeros(Nvec);
	for kk = 1:rr
		xx = cell(dd,1);
		for ii = 1:dd
			xx{ii} = randn(Nvec(ii), 1);
		end
		XX = XX + buildTens(xx);
	end

	%% Linear Measurements
	%AA = randn(MM, prod(Nvec))*1/sqrt(MM);
	%zz = randn(MM,1);
	%zz = zz./norm(zz)*sig;
	%yy = AA*vec(XX) + zz;
    AA = zeros(prod(Nvec),1);
    supp = randperm(prod(Nvec));
    AA(supp(1:MM)) = 1;
    yy = AA.*vec(XX) + randn(prod(Nvec),1)*sig;

	%% Main 
	[Xhat, out] = cpTIHT_completion(yy, supp(1:MM), rr, XX, opts);

	%% Plot results
	semilogy(out.err, markers{jj}, 'MarkerIndices', 1:opts.numIts/10:opts.numIts,'DisplayName', ['r = ' num2str(rr)])
	%semilogy(out.err, markers{jj}, 'DisplayName', ['r = ' num2str(rr)])
	
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
    fname = sprintf('%s_%dMM_%ddd_%.2fsig_%dnd', mfilename(pwd), MM, dd, sig, prod(Nvec));
    saveFigure(strcat('figs/', fname ,'.fig'))
    saveas(gcf, strcat('figs/', fname ,'.png'))
    save(strcat('data/',fname));
end
