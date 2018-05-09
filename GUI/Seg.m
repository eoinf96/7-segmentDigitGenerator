%%
% File    : Seg.m
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
%This function generates a segment of the 7-segment display, with a certain
%size, width and gap
%
% To Do
% -----
% Allow the user to pick the type of 7-segment-digit e.g rounded,  solid,
% diagonal etc, these types force the left, and right segments to be
% different.
% 
%
% INPUT
% -----
%
%   VertHeight  :   The height of a vertical segment
%
%   HorizHeight : The length of a horizontal segment
%
%   Thickness  :   Thickness of each segment
%
%   gap : The gap between each segment
%
%   type : This states where the segment will be in the 7-segment digit
%       Options are: 'VertLeft', 'VertRight', 'HorizMiddle', 'HorizTop'
%
%
% OUTPUT
% -----
%
%     Seg :  The segment as an array of size VertHeight * Thickness or
%     Thickness * HorizHeight provided if a horizontal or vertical segment.
%
% ________________________________________________________________________

%%

function [ Seg ] = Seg( VertHeight, HorizHeight, Thickness,gap, type )
step = 1;

if strcmp(type, 'VertLeft')
    Seg = ones(VertHeight, Thickness); %initialise the array
    Middle = ceil((Thickness+1)/2);
    
    Seg(1:gap, :) = 0; %If we have a gap needed then set both sizes of the segment to zero
    Seg(end-gap+1:end, :) = 0;
    for i = 1:Middle-1
        k = Middle - i;
        j = Middle +i;

        Seg(gap+1:gap+floor(step*i), [k,j]) = 0;%Form a triangle edge at both ends of the segment
        Seg(end-gap-floor(step*i)+1:end, [k,j]) = 0;
    end 
    
elseif strcmp(type, 'VertRight')
    Seg = ones(VertHeight, Thickness);%initialise the array
    Middle = ceil((Thickness+1)/2);
    
    Seg(1:gap, :) = 0;%If we have a gap needed then set both sizes of the segment to zero
    Seg(end-gap+1:end, :) = 0;
    for i = 1:Middle-1
        k = Middle - i;
        j = Middle +i;

        Seg(gap+1:gap+floor(step*i), [k,j]) = 0; %Form a triangle edge at both ends of the segment
        Seg(end-gap-floor(step*i)+1:end, [k,j]) = 0;
    end 
    
elseif strcmp(type, 'HorizMiddle')
    Seg = ones(Thickness, HorizHeight+2); %initialise the array
    
    if gap > 0%If we have a gap needed then set both sizes of the segment to zero
        Seg(:,1:gap) = 0;
        Seg(:, end-gap+1:end) = 0;
    end
    
    Middle = ceil((Thickness+1)/2);
    for i = 1:Middle-1
        k = Middle - i;
        j = Middle +i;

        Seg([k,j], 1:gap+floor(step*i)) = 0;%Form a triangle edge at both ends of the segment
        Seg([k,j], end-gap-floor(step*i)+1:end) = 0;
    end 


elseif strcmp(type, 'HorizTop')
    Seg = ones(Thickness, HorizHeight); %initialise the array
    
    if gap > 0%If we have a gap needed then set both sizes of the segment to zero
        Seg(:,1:gap) = 0;
        Seg(:, end-gap+1:end) = 0;
    end

    Middle = ceil((Thickness+1)/2);
    for i = 1:Middle-1
        k = Middle - i;
        j = Middle +i;

        Seg([k,j], 1:gap+floor(step*i)) = 0;%Form a triangle edge at both ends of the segment
        Seg([k,j], end-gap-floor(step*i)+1:end) = 0;
    end 
end

end



