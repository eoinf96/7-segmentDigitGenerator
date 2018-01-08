%%
% File    : GaussianF.m
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
%This function generates a gaussian filter for use in imfilter(). The
%filter is of size n*n and with variance sigma^2 
%
% 
%
% INPUT
% -----
%
%   n  :   Size of Gaussian Filter
%
%   sigma : Variance of Gaussian Filter
%
% OUTPUT
% -----
%
%     f :  Gaussian filter
%
% ________________________________________________________________________

%%
function f=GaussianF(n, sigma)
% n has to be an off number:

% Check
if ~mod(n,2)
    %Even number
    error('Even sized filter - must input an odd number')
end
size=n;
f=zeros(size,size); 

x0=(size+1)/2; %center
y0=(size+1)/2; %center

for i=-(size-1)/2:(size-1)/2
    for j=-(size-1)/2:(size-1)/2
        x=i+x0; %row
        y=j+y0; %col
        f(y,x)=exp(-((x-x0)^2+(y-y0)^2)/2/(sigma^2));
    end
end
%normalize gaussian filter
sum1=sum(f);
sum2=sum(sum1);
f=f/sum2;
end

