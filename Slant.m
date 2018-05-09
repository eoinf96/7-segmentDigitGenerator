%%
% File    : Slant.m
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
%This function slants thbe image by shifting the scene about the horizontal
%centre
%
% 
%
% INPUT
% -----
%
%   Scene  :   Input Gray Scale image
%
%   Slant : Slant factor
%
%   BackGround : The background intensity.
%
% OUTPUT
% -----
%
%     Scene1 :  Slanted output image
%
% ________________________________________________________________________

function [ Scene1 ] = Slant( Scene, Slant, BackGround )

Scene1 = BackGround * ones(length(Scene), length(Scene));

%Find the middle row (or at least the row just above the middle row
MiddleRow = ceil(size(Scene,1)/2);
Scene1(MiddleRow, :) = Scene(MiddleRow, :);

if Slant > 0 %Slant in a clockwise direction.

    for i = 1:MiddleRow-1 %Go through rows
        j = MiddleRow +i; %Rows below the middle row
        k = MiddleRow - i;%Rows above the middle row

        Diff = floor(Slant *i); % how much to move each row by

        Scene1(j, 1:end-Diff) = Scene(j, Diff+1:end);
        Scene1(k, Diff+1:end) = Scene(k, 1:end-Diff);
    end


elseif Slant < 0 %Slant in an anti clockwise direction.
    for i = 1:MiddleRow-1
        j = MiddleRow -i; 
        k = MiddleRow + i;

        Diff = -floor(Slant *i);

        Scene1(j, 1:end-Diff) = Scene(j, Diff+1:end);
        Scene1(k, Diff+1:end) = Scene(k, 1:end-Diff);
    end
else %If the slant is 0 then the scene will be the same.
    Scene1 = Scene;
end
    
end

