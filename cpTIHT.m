function [That, mets] =  cpTIHT(yy, AA, rr, Tlr, opts)
% TIHT for low CP rank tensors

%% Inputs
% yy: mx1 linear measurements
% AA: mxn measurement matrix
% rr: target CP rank 
% Tlr: true tensor being approximated
% opt
%   .numits: number of iterations, default 100
%   .mu: stepsize for IHT, default 1

%% Outputs
% That: approximated tensor
% mets
%   .err: frobenious error per iteration


%% Set parameters
mu = 1;
numIts = 100;
if(exist('opts'))
  if(isfield(opts, 'mu'))
    mu = opts.mu;
  end
  if(isfield(opts, 'numIts'))
    numIts = opts.numIts;
  end
end

%% Initialization
Nvec = size(Tlr);
XX = randn(Nvec);
mets.err = [];
mets.time = [];
t = cputime;

%% Main Loop
for kk=1:numIts

   % IHT
   vXX = XX(:);
   WW = vXX + mu*AA'*(yy - AA*vXX);
   WW = reshape(WW, Nvec);
   XX_decomp = cpd(WW,rr);
   XX = zeros(Nvec);
   for ii = 1:rr
      XX = XX + buildTens({XX_decomp{1}(:,ii), XX_decomp{2}(:,ii), XX_decomp{3}(:,ii)});
   end
   
   % Collect metrics
   mets.err(kk) = frob(XX - Tlr);
   mets.time(kk) = cputime - t;

end

That = XX;








