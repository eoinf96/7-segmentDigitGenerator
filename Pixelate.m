%%
% File    : Pixelate.m
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
%This function pixelates an inputted image, Scene, by grouping pixels
%together into size PixelationSize and taking their maximum intensity. The
%inputted scene must be a grayscale image and the PixelationSize must be a
%whole number
%
% 
%
% INPUT
% -----
%
%   Scene  :   Input Gray Scale image
%
%   PixelationSize : Factor increase in size of pixels.
%
% OUTPUT
% -----
%
%     Scene1 :  Pixelated output image
%
% ________________________________________________________________________


function [ Scene1 ] = Pixelate( Scene , PixelationSize)

if PixelationSize ~= 1
    %If the Pixelation size is 1 then we have no change in image

    i = 1 ; %y
    while i + PixelationSize -1 < length(Scene)
        j = 1; %x
        while j+PixelationSize-1 < length(Scene)
            %Move along in the xdirection and then the ydirection
            
            Area = Scene(i:i+PixelationSize-1, j:j+PixelationSize-1);
            
            
%             pix = max(max(Area)); %The new Scene value will be the maximum value of the Area
            pix = (median(Area(:)));
            
            %If pix is not a value in the Area then chose the closest value
            if ~ismember(Area(:), pix)
                A = Area(:);
                [~, index] = min(abs(Area - pix));
                pix = A(index(1));
            end
            Scene1(i:i+PixelationSize-1, j:j+PixelationSize-1) = pix;

            j = j+PixelationSize-1; 
            %
        end
        i = i+PixelationSize-1;
    end

else
    Scene1 = Scene;
    
end


end

