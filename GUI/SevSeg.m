function Scene = SevSeg(Digit, Dimensions,Colour, Distort)
%Seven segment image builder
%Format:
%Scene=SevSeg(digit)
%Scene=SevSeg(digit,mode,matrixHeight,poligonWidth,distans,matrixBand,stat)
%
%Input:
%   %all dimensions in pixels
%   digit:        the digit to display
%   Dimensions:    Struct containing the dimensions of the digit including:
%                   DigitWidth - Has to be odd
%                   SegWidth
%                   SegGap
% For imformation regarding these dimensions - see image.
%   
%   Colour: Struct containing the grey scale of the image including:   
%                   Digit_Intensity (on scale of 0 to 1)
%                   Background_Intensity (on scale of 0 to 1)
%                   Invert (Binary 1 or 0)
%
%   Distort: Struct containg the paramters to distort the image, including:
%                   Gauss_Size - Gaussian blur Size
%                   Gauss_SD - Gaussian blur Variance. See GaussianF.m
%                   PixelationSize - See Pixelate.m
%                   Angle - How much to orientate the digit by - in degrees
%                   Slant - See Slant.m
%                   Mean_Gauss - Should always equal 0
%                   V_Gauss - Gaussian Noise
%                   d_sp - Salt and Pepper noise
%
%Output:
%         Scene        The image with seven segment representation of input digit
%
%               

%Default input params if only a digit wants to be viewed
if  nargin == 1
    Dimensions.DigitWidth = 19; 
    Dimensions.SegWidth = 7;
    Dimensions.SegGap = 0;
    
    Colour.Digit_Intensity = 0;
    Colour.Background_Intensity = 1;
    Colour.Invert = 0;
    
    Distort.Gauss_Size = 1;
    Distort.Gauss_SD = 1;
    Distort.PixelationSize = 1;
    Distort.Angle = 0;
    Distort.Slant = 0;
    Distort.Mean_Gauss = 0;
    Distort.V_Gauss = 0.0;
    Distort.d_sp = 0;
end

SceneWidth = 56;    %56 pixels by 56 pixels
SceneHeight = 56;
Scene = zeros(SceneWidth,SceneHeight); %Total Scene 
Dimensions.DigitHeight = 42; 
%Height of the digit


VertHeight = ceil(Dimensions.DigitHeight/2);% Defines the vertical height of each segment


%    -a-
%  f|   |b
%    -g-
%  e|   |c
%    -d-  

%Indexes for segments of 7- segment display
ai = 0;bi = 0;ci = 0;di = 0;ei = 0;fi = 0;gi = 0;

%Find which segments need to be active. - Refer to above layout for
%references
switch Digit
    case 0
        ai=1;bi=1;ci=1;di=1;ei=1;fi=1;
    case 1
        bi=1;ci=1;
    case 2
        ai=1;bi=1;di=1;ei=1;gi=1;
    case 3
        ai=1;bi=1;di=1;ci=1;gi=1;
    case 4
        bi=1;ci=1;gi=1;fi=1;
    case 5
        ai=1;ci=1;di=1;gi=1;fi=1;
    case 6
        ai=1;ci=1;di=1;ei=1;fi=1;gi=1;
    case 7
        ai=1;bi=1;ci=1;
    case 8
        ai=1;bi=1;ci=1;di=1;ei=1;fi=1;gi=1;
    case 9
        ai=1;bi=1;ci=1;di=1;fi=1;gi=1;
end

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Middle is a reference for horizontal bars starting from g
Middle = [ceil((SceneHeight)/2), ceil((SceneWidth)/2)];

%Centre is a reference for vertical bars starting from b
Centre = Middle + [- (ceil((VertHeight+1)/2)-1), ceil((Dimensions.DigitWidth+1)/2)];

% The half parameters help to define the bounding box of each box (so each
% box is defined by thicknesses from its centre:
%   -----------------------------------------------------
%   |                        |                          |
%   |                  (HalfThickness)                  | 
%   |                        |                          |
%   |----(HalfLength)-----(Middle)----(HalfLength)----- |
%   |                        |                          |
%   |                  (HalfThickness)                  | 
%   |                        |                          |
%   -----------------------------------------------------
%

HalfThickness = ceil((Dimensions.SegWidth-1)/2);
HalfLengthVert = ceil((VertHeight-1)/2);
HalfLengthHoriz = floor((Dimensions.DigitWidth-1)/2);

%First lets place g
if gi
    g = Seg(1, Dimensions.DigitWidth, Dimensions.SegWidth,Dimensions.SegGap, 'HorizMiddle');
    gheight = (Middle(1)- HalfThickness):(Middle(1)+ HalfThickness);
    gwidth = (Middle(2)- HalfLengthHoriz-1):(Middle(2)+ HalfLengthHoriz+1);

    Scene(gheight, gwidth) = Scene(gheight, gwidth) + g;
end

%Place a 
if ai 
    a = Seg(1,Dimensions.DigitWidth, Dimensions.SegWidth,Dimensions.SegGap, 'HorizTop');
    aheight = ((Middle(1)- HalfThickness):(Middle(1)+ HalfThickness)) - VertHeight;
    awidth = (Middle(2)- HalfLengthHoriz):(Middle(2)+ HalfLengthHoriz);

    Scene(aheight, awidth) = Scene(aheight, awidth) + a;
end

%Place d - a has the same width as g but its height is offset by Height
if di
    d = Seg(1,Dimensions.DigitWidth, Dimensions.SegWidth,Dimensions.SegGap, 'HorizTop');
    dheight = ((Middle(1)- HalfThickness):(Middle(1)+ HalfThickness)) + VertHeight;
    dwidth = (Middle(2)- HalfLengthHoriz):(Middle(2)+ HalfLengthHoriz);

    Scene(dheight, dwidth) = Scene(dheight, dwidth) + d;
end

%Place b
if bi
    b = Seg(VertHeight,1, Dimensions.SegWidth,Dimensions.SegGap, 'VertRight');
    bheight = ((Centre(1)- HalfLengthVert):(Centre(1)+ HalfLengthVert)) -1 ;
    bwidth = (Centre(2)- HalfThickness):(Centre(2)+ HalfThickness);

    Scene(bheight, bwidth) = Scene(bheight, bwidth) + b;
end

%Place c
if ci
    c = Seg(VertHeight,1, Dimensions.SegWidth,Dimensions.SegGap, 'VertRight');
    cheight = ((Centre(1)- HalfLengthVert):(Centre(1)+ HalfLengthVert)) + VertHeight;
    cwidth = (Centre(2)- HalfThickness):(Centre(2)+ HalfThickness);

    Scene(cheight, cwidth) = Scene(cheight, cwidth) + c;
end

%Place e
if ei
    e = Seg(VertHeight,1, Dimensions.SegWidth,Dimensions.SegGap, 'VertLeft');
    eheight = ((Centre(1)- HalfLengthVert):(Centre(1)+ HalfLengthVert)) + VertHeight;
    ewidth = ((Centre(2)- HalfThickness):(Centre(2)+ HalfThickness)) - Dimensions.DigitWidth-1;

    Scene(eheight, ewidth) = Scene(eheight, ewidth) + e;
end

%Place f
if fi
    f = Seg(VertHeight,1, Dimensions.SegWidth,Dimensions.SegGap, 'VertLeft');
    fheight = ((Centre(1)- HalfLengthVert):(Centre(1)+ HalfLengthVert)) - 1;
    fwidth = ((Centre(2)- HalfThickness):(Centre(2)+ HalfThickness)) - Dimensions.DigitWidth-1;

    Scene(fheight, fwidth) = Scene(fheight, fwidth) + f;
end
%Now the image is defined with the segments in the correct place and a
%white digit on a black background.
%%%%%% Binarise and invert - We binarise just in case any additive features
%%%%%% have caused a greyscale
Thresh = graythresh(Scene);
Scene = im2bw(Scene, Thresh);
Scene = 1 - Scene;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GrayScale -- Define the background and foreground colour - simulate cheap displays
    
Scene(Scene == 0) = Colour.Digit_Intensity - 0.0001;
Scene(Scene == 1) = Colour.Background_Intensity;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now Distort the image by adding various rotations, noise and pixelations
% Pixelate
Scene = Pixelate(Scene, Distort.PixelationSize);

%Rotation
Scene = imrotate(Scene,Distort.Angle, 'crop');
Mrot = ~imrotate(true(size(Scene)),Distort.Angle, 'crop');
Scene(Mrot&~imclearborder(Mrot)) = Colour.Background_Intensity;


% Slant
Scene = Slant(Scene, Distort.Slant, Colour.Background_Intensity);


% Noise
%Gaussian Noise -- Statistical Noise with normal distribution
Scene = imnoise(Scene, 'Gaussian', Distort.Mean_Gauss, Distort.V_Gauss);
% Salt and Pepper Noise
Scene = imnoise(Scene,'salt & pepper',Distort.d_sp);

% Add Gaussian Blur
%Generate Gaussian Filter
%The Gaussian blur affects the right and bottom edges of the images, in
%order to stop this we must save the edges
SceneRight = Scene(:, end);
SceneBottom = Scene(end,:);

%Apply filter
G = GaussianF(Distort.Gauss_Size, Distort.Gauss_SD);
Scene = imfilter(Scene, G, 'replicate');


%% Show the image and save it

if Colour.Invert % Then switch the background and foreground colour
   Scene = imcomplement(Scene);
end
% Scene = imresize(Scene, 0.5, 'nearest'); % Use nearest neighbour to preserve edges and not cause more blurring 

end