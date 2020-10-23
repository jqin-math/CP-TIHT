function [T] = buildTens(U)
% Builds a tensor using CP factors U1, U2, U3

T = tmprod((U{1})*(U{2}'), U{3},3);