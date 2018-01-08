%%
% File    : Save.m
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
%This function saves digits in the location given by SaveLoc. The
%variations of digits to be saved are given by Min, Max, Step.
%
% 
% INPUT
% -----
%
%   SaveLoc  :   String of the exact path of the folder in which digits are
%   saved.
%
%   Min : A structure containing the Minimum value of each parameter
%
%   Max : A structure containing the Maximum value of each parameter
%
%   Step : A structure containing the Step value of each parameter
%
% OUTPUT
% -----
%
%     
%
% ________________________________________________________________________

%%
function [  ] = Save( SaveLoc, Min, Max, Step )


Min = cell2mat(struct2cell(Min));
Step = cell2mat(struct2cell(Step));
Max = cell2mat(struct2cell(Max));
%Convert all structures to matrices. 

TotalVar = 1; %Find the total number of images to be produced and the number of variations of each parameter.
for i = 1:length(Min)
    Var(i) = length(Min(i):Step(i):Max(i));
    TotalVar = TotalVar * Var(i);
end
fprintf('Total Number of Images to Save: %s \n', num2str(TotalVar))

%%%%%
e(1)=0; %e is a vector containing the time it takes to save each file. 

%load a waitbar with a pause and cancel button
h = waitbar(0,'1','Name','Saving Images','CreateCancelBtn',@cancelButtonCallback);
setappdata(h,'canceling',0)
hChildren = get(h,'Children');
    for k=1:length(hChildren)
        hChild = hChildren(k);
        if isfield(get(hChild),'Style')  && strcmpi(get(hChild,'Style'),'pushbutton')
           hChildPos = get(hChild,'Position');
           pauseBtnPos = hChildPos;
           pauseBtnPos(1) = pauseBtnPos(1) - pauseBtnPos(3) - 1;
           hPauseBtn = uicontrol(h, 'Style', 'pushbutton', 'String', 'Pause',...
                                 'Position', pauseBtnPos,...
                                 'Callback', @pauseButtonCallback);    
        end
    end
pauseWaitbar = 0;
cancelWaitbar = 0; 
i = 1;
while i <TotalVar && ~cancelWaitbar

if pauseWaitbar % This gives the while loop something to do while the pause button is pressed
    pause(.1);
end


if ~pauseWaitbar %If we are running
    % Calculate the time left to run  as the average time of each run
    % multiplied by the number of runs left.
    TIMELEFT = mean(e) * (TotalVar-i);
    
    %Find number of hours, mins secs 
   [~, ~, ~, H, M, S] = datevec(TIMELEFT./(60*60*24));
    %We only care about the last 3
    
    t = cputime; % Start the timer
    %Update the waitbar
    waitbar(i / TotalVar,h,sprintf('Time Left = %.0f Hours,  %.0f Minutes,  %.0f Seconds',H, M, S))
    i = i + 1;
    
    %Find the values of each parameter
    Params = FindParams(i, Min, Step, Var);
    
    
    %Update the structures with the current values.
    Dimensions.DigitWidth = Params(1);
    Dimensions.SegWidth = Params(2);
    Dimensions.SegGap = Params(3);

    Distort.Angle = Params(4);
    Distort.Slant = Params(5);

    Colour.Digit_Intensity = Params(6);
    Colour.Background_Intensity = Params(7);
    Colour.Invert = Params(8);

    Distort.PixelationSize = Params(9);
    Distort.V_Gauss = Params(10);
    Distort.Mean_Gauss = 0 ;
    Distort.d_sp = Params(11);
    Distort.Gauss_Size = Params(12);
    Distort.Gauss_SD = Params(13);

    Digit = Params(14);

    % Generate the Scene with the current parameters.
    Scene = SevSeg(Digit, Dimensions, Colour, Distort);

    %%%%Label each file so that they can be spread among test and train sets
    %%%%later
    Label =  Params(1:end-1)'; %Subtract 1 as the last param is digit
    Label = mat2cell(Label,1, repmat(1,size(Label)));
    tag = strjoin(cellfun(@num2str,Label, 'UniformOutput',false),'_');
    tag = strrep(tag,'.','-');
    %%%%%%

    % Save the file in the input location
    name = strcat(SaveLoc, sprintf('%.0f_%s',Digit, tag));
    name = strcat(name, '.png');
    imwrite(Scene,name)

    %How long has this taken?
    e(i) = cputime-t;
    end
end
delete(h) %Delete the waitbar


    function pauseButtonCallback(hSource, eventdata)
        if ~pauseWaitbar % If the pause button is pressed change the button to 'play'
        hPauseBtn = uicontrol(h, 'Style', 'pushbutton', 'String', 'Play',...
                 'Position', pauseBtnPos,...
                 'Callback', @pauseButtonCallback); 
        else % If the play button is pressed change the button to 'pause'
           hPauseBtn = uicontrol(h, 'Style', 'pushbutton', 'String', 'Pause',...
                     'Position', pauseBtnPos,...
                     'Callback', @pauseButtonCallback); 
            
        end
        pauseWaitbar = ~pauseWaitbar;
    end
    function cancelButtonCallback(hSource, eventdata)
        cancelWaitbar = 1;
    end

end

