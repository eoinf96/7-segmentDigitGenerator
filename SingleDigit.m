% clear all

Digit =8;
%Which digit would you like to plot?

%% The Dimensions cell defines the parameters that define the digit.
Dimensions.DigitWidth = 27; % Has to be odd
%Min = 19; max = 43

Dimensions.SegWidth = 9;
%Min = 5; Max = 11

Dimensions.SegGap = 1;
%Min = 0; Max = 3
%% The Colour{} cell defines the greyscale of the image

Colour.Digit_Intensity = 0;
%Min = 0; Max = 0.4
Colour.Background_Intensity = 1;
%Min = 0.6; Max = 1

% Invert?
Colour.Invert = 0;
%0 = No Invert; 1 = Invert

%% The Cell Distort{} Defines the parameters that try to distort the Digit.

%Gaussian Blur
Distort.Gauss_Size =3;
%Min = 1; Max = 3
Distort.Gauss_SD = 1;
%Min 1, Max = 3

%Pixelate
Distort.PixelationSize = 4;
%Min = 1; Max = 3

%Rotation angle
Distort.Angle = 0;
%Min = -25, Max = 25

Distort.Slant = 0;
%Min = -0.5; Max = 0.5

% Noise Parameters
%Gaussian Noise
Distort.Mean_Gauss = 0;
% Keep at 0
Distort.V_Gauss = 0.00;
% Min = 0 Max = 0.01

%Salt and Pepper Noise
Distort.d_sp = 0.0;
%Min = 0; Max = 0.08
%%
Scene = SevSeg(Digit,Dimensions,Colour, Distort);
imshow(Scene)
imwrite(Scene,'Digit.png')