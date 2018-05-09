%%
% File    : FindParams.m
% Author  : Eoin Finnegan
% Created : Dec 15th 2017
% ________________________________________________________________________
%
% This file is part of 7-segment-digit
%
% 7-segment-digit: Library for generating 7-segment digit database
%
% PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
%
% You may contact the author by e-mail (eoinfinnegan96@hotmail.co.uk)
% ________________________________________________________________________
%
% DESCRIPTON
% ----------
%
%This function outputs the values of the parameters given a
%set number of runs in a for loop, i,it's starting values, Min, and how large each step
%is, Step. The vector Var tells us the maximum number of steps in each
%paramter. We run through the first variable by Var(1) (it's maximum number
%of runs), we then incremenet the next variable, reset the original and
%continue again until the second variable meets it's maximum value in which
%case we reset the first teo values or if we have reached the number of
%iterations, i, of the for loop.
% 
% e.g. a for loop in which 3 parameters have been varied. The 3 parameters
% have Min, Step and Var vectors: [1;2;3], [2;2;2]; and [6;7;8]
% respectively
%
% If we have run through the for loop 10 times then the output of the
% function will be: [ 9; 4;3].
% 
%
% INPUT
% -----
%
%   i  :   the number of runs completed in the loop
%
%   Min :  A vector containing the minimum values of each parameter
%
% %   Step : The size of each step of each parameters 
% 
%     Var: The maximum number of steps of each parameter
% %
% OUTPUT
% -----
%
%     Values :  The current values of each parameter at iteration i
%
% ________________________________________________________________________

%%
function [ Values] = FindParams( i,Min, Step, Var )

I = zeros(length(Var), 1);
for j = 1:length(I)
    I(j) = rem( i,Var(j));
    i = fix( i/Var(j));

end

Values = Min + Step .* I;