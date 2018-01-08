MatLab Code and GUI for generating dataset of 7-segment digits.

The GUI (Shown below) allows the user to view the effects of variations on specific parameters. The user can then enter Max, Min and Step values to generate a dataset.
![GUI](Pictures/GUI.jpg)

The parameter variations can be split into 3 categories:

Dimensions --> Dimensions(1) = Digit Width, Dimensions(3) = Segment Width, Dimensions(3) = SegmentGap

Colour --> Colour(1) = Digit Intensity, Colour(2) = Background Intensity, Colour(3) = Invert

Distort --> Distort(1) = Angle, Distort(2) = Slant, Distort(3) = Pixelation, Distort(4) = Gaussian Noise Variance, Distort(5) = Gaussian Noise Mean, Distort(6) = Salt and Pepper Noise, Distort(7) = Gaussian Blur Kernel Size, Distort(8) = Gaussian Blur Variance

Each image is saved as a 56* 56 pixel .png image. The name of the saved file includes the digit variations as:

Name = 'Dimensions(1)_Dimensions(2)_Dimensions(3)_Distort(1)_Distort(2)_Colour(1)_Colour(2)_Colour(3)_Distort(3)_Distort(4)_Distort(5)_Distort(6)_Distort(7)_Distort(8).png'
Any negative values have their decimal point replaced with a '-'

Example Digit:

![Digit](Pictures/Digit.png)