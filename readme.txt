
README

Paper: ``Iterative Hard Thresholding for Low CP-rank Tensor Models" by 
R. Grotheer, S. Li, A. Ma, D. Needell, J. Qin
https://arxiv.org/pdf/1908.08479.pdf


Requirements:
Tensorlab (https://www.tensorlab.net/)

Functions: 
	- buildTens.m: Utility function to build tensor 
	- cpTIHT.m: Tensor Iterative Hard Thresholding for Low CP-rank Tensors
	- cpTIHT_completion.m: Tensor Iterative Hard Thresholding for Low CP-rank Tensor Completion

Scripts: 
	- runme_synth_varyM.m: Script for running CP-TIHT on synthetic data when varying the number of measurements
	- runme_synth_varyR.m: Script for running CP-TIHT on synthetic data when varying the CP-rank
	- runme_candle.m: Script for running candle experiment 
	- runme_compl_varyM.m: Script for running CP-TIHT on completion problem when varying the number of measurements
	- runme_compl_varyR.m: Script for running CP-TIHT on completion problem when varying the rank
