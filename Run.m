clear all

%Define: Min, Step and Max for each Parameter

%%
Min.DigitWidth = 19;
Step.DigitWidth = 12;
Max.DigitWidth = 43;

Min.SegmentWidth = 5;
Step.SegmentWidth = 6;
Max.SegmentWidth = 11;

Min.SegmentGap = 0;
Step.SegmentGap = 3;
Max.SegmentGap = 3;

%%
Min.Angle = -10;
Step.Angle = 10;
Max.Angle = 10;

Min.Slant = -0.4;
Step.Slant = 0.4;
Max.Slant = 0.4;

%%
Min.DigitGray = 0;
Step.DigitGray = 0.2;
Max.DigitGray = 0.2;

% %BackGround Gray = 1 - Digit Gray

Min.BackGray = 1 - Max.DigitGray;
Step.BackGray =Step.DigitGray;
Max.BackGray = 1 - Min.DigitGray;

Min.Invert = 0;
Step.Invert = 1;
Max.Invert = 1;

%%
Min.Pixelation = 1;
Step.Pixelation = 2;
Max.Pixelation = 3;

Min.GaussianNoise = 0;
Step.GaussianNoise = 0.01;
Max.GaussianNoise = 0.01;

Min.SaltAndPepper = 0;
Step.SaltAndPepper = 0.01;
Max.SaltAndPepper = 0.01;

Min.GaussianSize = 1;
Step.GaussianSize = 2;
Max.GaussianSize = 3;

Min.GaussianVariance = 1;
Step.GaussianVariance = 2;
Max.GaussianVariance = 1;

%%

Min.Digit =0;
Step.Digit=1;
Max.Digit =9;

%% Convert to Matrices to be able to perfom operations on

SaveLoc = '/Users/Eoinfinnegan/Documents/7-segment-digit/SampleImages9DigitsBlur_Rotation/';
Save(SaveLoc, Min, Max, Step)
                             