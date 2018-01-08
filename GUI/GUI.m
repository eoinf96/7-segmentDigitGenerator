function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to refresh (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% Function to plot the data even when the refresh button isnt pressed

function plotgui(handles)
    %Get Digit 
    txt = get(handles.Digit_Select,'Value');
    Digit = double(txt) - 1;

    %Get Dimensions
    Dimensions.DigitWidth = get(handles.width_slider,'Value');
    Dimensions.SegWidth = get(handles.segwidth_slider,'Value');
    Dimensions.SegGap = get(handles.gap_slider,'Value');

    %Get Colour
    Colour.Digit_Intensity = get(handles.digit_intensity_slider,'Value');
    Colour.Background_Intensity = get(handles.background_intensity_slider,'Value');
    Colour.Invert = get(handles.invert, 'Value');

    %Set Remaining
    Distort.Gauss_Size = get(handles.gaussianblur_ker_slider,'Value');
    Distort.Gauss_SD = get(handles.gaussianblur_sd_slider,'Value');
    Distort.PixelationSize = get(handles.pixel_slider,'Value');
    Distort.Angle = get(handles.angle_slider,'Value');
    Distort.Slant = get(handles.slant_slider,'Value');
    Distort.Mean_Gauss = 0;
    Distort.V_Gauss = get(handles.gaussiannoise_var_slider,'Value');
    Distort.d_sp = get(handles.saltpepp_slider,'Value');

    if ~mod(Dimensions.DigitWidth,2)
        set(handles.SmallDigit,'visible','off') %hide the current axes
        set(get(handles.SmallDigit,'children'),'visible','off') %hide the current axes contents
        
        set(handles.LargeDigit,'visible','off') %hide the current axes
        set(get(handles.LargeDigit,'children'),'visible','off') %hide the current axes contents  
        
        set(handles.ErrorMessage, 'Visible', 'on')
        set(handles.ErrorKernelSize, 'Visible', 'off')
        
        
     elseif rem(Distort.Gauss_Size,1) ~= 0 || rem(Distort.PixelationSize,1) ~=0
        
        set(handles.SmallDigit,'visible','off') %hide the current axes
        set(get(handles.SmallDigit,'children'),'visible','off') %hide the current axes contents
        
        set(handles.LargeDigit,'visible','off') %hide the current axes
        set(get(handles.LargeDigit,'children'),'visible','off') %hide the current axes contents  
        
        set(handles.ErrorKernelSize, 'Visible', 'on')
        set(handles.ErrorMessage, 'Visible', 'off')
    else

        Scene = SevSeg(Digit, Dimensions,Colour, Distort);

        axes(handles.SmallDigit);
        imshow(Scene,'InitialMagnification', 1);

        axes(handles.LargeDigit);
        imshow(Scene)
        
        set(handles.ErrorMessage, 'Visible', 'off')
        set(handles.ErrorKernelSize, 'Visible', 'off')
    end

%%


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Set the initial axes:
Scene = SevSeg(0);

axes(handles.SmallDigit);
imshow(Scene);

axes(handles.LargeDigit);
imshow(Scene)


% Initialise Edit Box Values
% set the slider range and step size
numSteps = get(handles.width_slider, 'Max') - get(handles.width_slider, 'Min');
set(handles.width_slider, 'SliderStep', [2/(numSteps) , 2/(numSteps) ]);
% save the current/last slider value
handles.lastSliderVal = get(handles.width_slider,'Value');
WidthInitial = num2str( get(handles.width_slider,'Value') );
set(handles.width_edit,'String', WidthInitial);

numSteps = get(handles.segwidth_slider, 'Max') - get(handles.segwidth_slider, 'Min');
set(handles.segwidth_slider, 'SliderStep', [1/(numSteps) , 1/(numSteps) ]);
% save the current/last slider value
handles.lastSliderVal = get(handles.segwidth_slider,'Value');
SegWidthInitial = num2str( get(handles.segwidth_slider,'Value') );
set(handles.segwidth_edit,'String', SegWidthInitial);

numSteps = get(handles.gap_slider, 'Max') - get(handles.gap_slider, 'Min');
set(handles.gap_slider, 'SliderStep', [1/(numSteps) , 1/(numSteps) ]);
% save the current/last slider value
handles.lastSliderVal = get(handles.gap_slider,'Value');
GapInitial = num2str( get(handles.gap_slider,'Value') );
set(handles.gap_edit,'String', GapInitial);


DigitIntensityInitial = num2str( get(handles.digit_intensity_slider,'Value') );
set(handles.digit_intensity_edit,'String', DigitIntensityInitial);

BackIntensityInitial = num2str( get(handles.background_intensity_slider,'Value') );
set(handles.background_intensity_edit,'String', BackIntensityInitial);


% add a continuous value change listener
if ~isfield(handles,'hListener')
    handles.hListener = addlistener(handles.width_slider,'ContinuousValueChange',@respondToContSlideCallback);
    handles.hListener = addlistener(handles.segwidth_slider,'ContinuousValueChange',@respondToContSlideCallback);
    handles.hListener = addlistener(handles.gap_slider,'ContinuousValueChange',@respondToContSlideCallback);
end


numSteps = get(handles.gaussianblur_ker_slider, 'Max') - get(handles.gaussianblur_ker_slider, 'Min');
set(handles.gaussianblur_ker_slider, 'SliderStep', [1/(numSteps) , 1/(numSteps) ]);
% save the current/last slider value
handles.lastSliderVal = get(handles.gaussianblur_ker_slider,'Value');
GaussBlurKerInitial = num2str( get(handles.gaussianblur_ker_slider,'Value') );
set(handles.gaussianblur_ker_edit,'String', GaussBlurKerInitial);

GaussBlurSDInitial = num2str( get(handles.gaussianblur_sd_slider,'Value') );
set(handles.gaussianblur_sd_edit,'String', GaussBlurSDInitial);

AngleInitial = num2str( get(handles.angle_slider,'Value') );
set(handles.angle_edit,'String', AngleInitial);

SlantInitial = num2str( get(handles.slant_slider,'Value') );
set(handles.slant_edit,'String', SlantInitial);

GaussNoiseMeanInitial = num2str( get(handles.gaussiannoise_mean_slider,'Value') );
set(handles.gaussiannoise_mean_edit,'String', GaussNoiseMeanInitial);

GaussNoiseVarInitial = num2str( get(handles.gaussiannoise_var_slider,'Value') );
set(handles.gaussiannoise_var_edit,'String', GaussNoiseVarInitial);


numSteps = get(handles.pixel_slider, 'Max') - get(handles.pixel_slider, 'Min');
set(handles.pixel_slider, 'SliderStep', [1/(numSteps) , 1/(numSteps) ]);
% save the current/last slider value
handles.lastSliderVal = get(handles.pixel_slider,'Value');
PixelationInitial = num2str( get(handles.pixel_slider,'Value') );
set(handles.pixel_edit,'String', PixelationInitial);



SaltPeppInitial = num2str( get(handles.saltpepp_slider,'Value') );
set(handles.saltpepp_edit,'String', SaltPeppInitial);


if ~isfield(handles,'hListener')
    handles.hListener = addlistener(handles.pixel_slider,'ContinuousValueChange',@respondToContSlideCallback);
    handles.hListener = addlistener(handles.gaussianblur_ker_slider,'ContinuousValueChange',@respondToContSlideCallback);
end

update_Dimension_Variables(handles)
update_Colour_Variables(handles)
update_Distort_Variables(handles)
 
 % Update handles structure
guidata(hObject, handles);

% 



% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Digit_Select.
function Digit_Select_Callback(hObject, eventdata, handles)
% hObject    handle to Digit_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Digit_Select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Digit_Select

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function Digit_Select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Digit_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Refresh.
function Refresh_Callback(hObject, eventdata, handles)
% hObject    handle to Refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

WidthInitial = 19;
SegWidthInitial = 5;
GapInitial = 0;

DigitIntensityInitial = 0;
BackIntensityInitial = 1;
InvertInitial = 0;

GaussBlurKerInitial = 1;
GaussBlurSDInitial = 1;
PixelationInitial = 1;
AngleInitial = 0;
SlantInitial = 0;
GaussNoiseVarInitial = 0;
SaltPeppInitial = 0;

%Set Dimensions
set(handles.width_slider,'Value', WidthInitial);
set(handles.width_edit,'String', num2str(WidthInitial));
set(handles.segwidth_slider,'Value', SegWidthInitial);
set(handles.segwidth_edit,'String', num2str(SegWidthInitial));
set(handles.gap_slider,'Value', GapInitial);
set(handles.gap_edit,'String', num2str(GapInitial));

%Get Colour
set(handles.digit_intensity_slider,'Value', DigitIntensityInitial);
set(handles.digit_intensity_edit,'String', num2str(DigitIntensityInitial));
set(handles.background_intensity_slider,'Value', BackIntensityInitial);
set(handles.background_intensity_edit,'String', num2str(BackIntensityInitial));
set(handles.invert, 'Value', InvertInitial);

%Set Remaining
set(handles.gaussianblur_ker_slider,'Value', GaussBlurKerInitial);
set(handles.gaussianblur_ker_edit,'String', num2str(GaussBlurKerInitial));
set(handles.gaussianblur_sd_slider,'Value', GaussBlurSDInitial);
set(handles.gaussianblur_sd_edit,'String', num2str(GaussBlurSDInitial));
set(handles.pixel_slider,'Value', PixelationInitial);
set(handles.pixel_edit,'String', num2str(PixelationInitial));
set(handles.angle_slider,'Value', AngleInitial);
set(handles.angle_edit,'String', num2str(AngleInitial));
set(handles.slant_slider,'Value', SlantInitial);
set(handles.slant_edit,'String', num2str(SlantInitial));
set(handles.gaussiannoise_var_slider,'Value', GaussNoiseVarInitial);
set(handles.gaussiannoise_var_edit,'String', num2str(GaussNoiseVarInitial));
set(handles.saltpepp_slider,'Value', SaltPeppInitial);
set(handles.saltpepp_edit,'String', num2str(SaltPeppInitial));

plotgui(handles)


% disp(['Refresh SliderVal ' num2str(get(handles.slider9,'Value'))]);

% --- Executes during object creation, after setting all properties.
function SmallDigit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SmallDigit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate SmallDigit


% --- Executes on slider movement.
function width_slider_Callback(hObject, eventdata, handles)
% hObject    handle to width_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Width = num2str( floor(get(hObject,'Value') ));
set(handles.width_edit,'String', Width);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function width_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function segwidth_slider_Callback(hObject, eventdata, handles)
% hObject    handle to segwidth_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SegWidth = num2str( get(hObject,'Value') );
set(handles.segwidth_edit,'String', SegWidth);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function segwidth_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segwidth_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function width_edit_Callback(hObject, eventdata, handles)
% hObject    handle to width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_edit as text
%        str2double(get(hObject,'String')) returns contents of width_edit as a double
Width = str2double(get(hObject,'String'));
set(handles.width_slider,'Value',Width);

plotgui(handles)



% --- Executes during object creation, after setting all properties.
function width_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function segwidth_edit_Callback(hObject, eventdata, handles)
% hObject    handle to segwidth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segwidth_edit as text
%        str2double(get(hObject,'String')) returns contents of segwidth_edit as a double

SegWidth = str2double(get(hObject,'String'));
set(handles.segwidth_slider,'Value',SegWidth);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function segwidth_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segwidth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function gap_slider_Callback(hObject, eventdata, handles)
% hObject    handle to gap_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Gap = num2str( get(hObject,'Value') );
set(handles.gap_edit,'String', Gap);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function gap_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gap_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function gap_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gap_edit as text
%        str2double(get(hObject,'String')) returns contents of gap_edit as a double
Gap = str2double(get(hObject,'String'));
set(handles.gap_slider,'Value',Gap);

plotgui(handles)



% --- Executes during object creation, after setting all properties.
function gap_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

 % --- Executes on slider movement.
 function respondToContSlideCallback(hObject, eventdata)
 % hObject    handle to slider1 (see GCBO)
 % eventdata  reserved - to be defined in a future version of MATLAB
 % Hints: get(hObject,'Value') returns position of slider
 %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 % first we need the handles structure which we can get from hObject
 handles = guidata(hObject);
 % get the slider value and convert it to the nearest integer that is less
 % than this value
 newVal = floor(get(hObject,'Value'));
 % set the slider value to this integer 
 set(hObject,'Value',newVal);
 % now only do something in response to the slider movement if the 
 % new value is different from the last slider value
 if newVal ~= handles.lastSliderVal 
     % it is different, so we have moved up or down from the previous integer
     % save the new value
     handles.lastSliderVal = newVal;
     guidata(hObject,handles);
    % display the current value of the slider
 end


% --- Executes on slider movement.
function digit_intensity_slider_Callback(hObject, eventdata, handles)
% hObject    handle to digit_intensity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Intensity = num2str( get(hObject,'Value') );
set(handles.digit_intensity_edit,'String', Intensity);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function digit_intensity_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digit_intensity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in digit_intensity_edit.
function digit_intensity_edit_Callback(hObject, eventdata, handles)
% hObject    handle to digit_intensity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of digit_intensity_edit
DigitIntensity = str2double(get(hObject,'String'));
set(handles.digit_intensity_slider,'Value',DigitIntensity);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function digit_intensity_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digit_intensity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function background_intensity_slider_Callback(hObject, eventdata, handles)
% hObject    handle to background_intensity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Intensity = num2str( get(hObject,'Value') );
set(handles.background_intensity_edit,'String', Intensity);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function background_intensity_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to background_intensity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function background_intensity_edit_Callback(hObject, eventdata, handles)
% hObject    handle to background_intensity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of background_intensity_edit as text
%        str2double(get(hObject,'String')) returns contents of background_intensity_edit as a double

BackgroundIntensity = str2double(get(hObject,'String'));
set(handles.background_intensity_slider,'Value',BackgroundIntensity);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function background_intensity_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to background_intensity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in invert.
function invert_Callback(hObject, eventdata, handles)
% hObject    handle to invert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of invert

plotgui(handles)


% --- Executes on slider movement.
function gaussianblur_ker_slider_Callback(hObject, eventdata, handles)
% hObject    handle to gaussianblur_ker_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
GaussBlurKer = num2str( get(hObject,'Value') );
set(handles.gaussianblur_ker_edit,'String', GaussBlurKer);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function gaussianblur_ker_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussianblur_ker_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function gaussianblur_ker_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussianblur_ker_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussianblur_ker_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussianblur_ker_edit as a double

GaussianBlurSize = str2double(get(hObject,'String'));
set(handles.gaussianblur_ker_slider,'Value',GaussianBlurSize);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function gaussianblur_ker_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussianblur_ker_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function angle_slider_Callback(hObject, eventdata, handles)
% hObject    handle to angle_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Angle = num2str( get(hObject,'Value') );
set(handles.angle_edit,'String', Angle);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function angle_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function angle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_edit as text
%        str2double(get(hObject,'String')) returns contents of angle_edit as a double

Angle = str2double(get(hObject,'String'));
set(handles.angle_slider,'Value',Angle);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function angle_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function gaussiannoise_mean_slider_Callback(hObject, eventdata, handles)
% hObject    handle to gaussiannoise_mean_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
GaussNoiseMean = num2str( get(hObject,'Value') );
set(handles.gaussiannoise_mean_edit,'String', GaussNoiseMean);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function gaussiannoise_mean_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussiannoise_mean_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function gaussiannoise_mean_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussiannoise_mean_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussiannoise_mean_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussiannoise_mean_edit as a double

GaussianNoiseMean = str2double(get(hObject,'String'));
set(handles.gaussiannoise_mean_slider,'Value',GaussianNoiseMean);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function gaussiannoise_mean_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussiannoise_mean_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function pixel_slider_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Pixel = num2str( get(hObject,'Value') );
set(handles.pixel_edit,'String', Pixel);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function pixel_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function pixel_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_edit as text
%        str2double(get(hObject,'String')) returns contents of pixel_edit as a double

Pixelation = str2double(get(hObject,'String'));
set(handles.pixel_slider,'Value',Pixelation);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function pixel_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function gaussianblur_sd_slider_Callback(hObject, eventdata, handles)
% hObject    handle to gaussianblur_sd_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
GaussBlurSD = num2str( get(hObject,'Value') );
set(handles.gaussianblur_sd_edit,'String', GaussBlurSD);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function gaussianblur_sd_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussianblur_sd_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function gaussianblur_sd_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussianblur_sd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussianblur_sd_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussianblur_sd_edit as a double

GaussianBlurSD = str2double(get(hObject,'String'));
set(handles.gaussianblur_sd_slider,'Value',GaussianBlurSD);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function gaussianblur_sd_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussianblur_sd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slant_slider_Callback(hObject, eventdata, handles)
% hObject    handle to slant_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Slant = num2str( get(hObject,'Value') );
set(handles.slant_edit,'String', Slant);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function slant_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slant_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function slant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to slant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slant_edit as text
%        str2double(get(hObject,'String')) returns contents of slant_edit as a double

Slant = str2double(get(hObject,'String'));
set(handles.slant_slider,'Value',Slant);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function slant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function gaussiannoise_var_slider_Callback(hObject, eventdata, handles)
% hObject    handle to gaussiannoise_var_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
GaussNoiseVar = num2str( get(hObject,'Value') );
set(handles.gaussiannoise_var_edit,'String', GaussNoiseVar);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function gaussiannoise_var_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussiannoise_var_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function gaussiannoise_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussiannoise_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussiannoise_var_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussiannoise_var_edit as a double

GaussianNoiseVar = str2double(get(hObject,'String'));
set(handles.gaussiannoise_var_slider,'Value',GaussianNoiseVar);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function gaussiannoise_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussiannoise_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function saltpepp_slider_Callback(hObject, eventdata, handles)
% hObject    handle to saltpepp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SaltPepp = num2str( get(hObject,'Value') );
set(handles.saltpepp_edit,'String', SaltPepp);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function saltpepp_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saltpepp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function saltpepp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to saltpepp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of saltpepp_edit as text
%        str2double(get(hObject,'String')) returns contents of saltpepp_edit as a double

SaltPepp = str2double(get(hObject,'String'));
set(handles.saltpepp_slider,'Value',SaltPepp);

plotgui(handles)


% --- Executes during object creation, after setting all properties.
function saltpepp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saltpepp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to width_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_min_edit as text
%        str2double(get(hObject,'String')) returns contents of width_min_edit as a double

Var = 1 + (str2num(get(handles.width_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.width_step_edit, 'String'));
set(handles.width_var_edit, 'String', num2str(Var));
update_Dimension_Variables(handles)


% --- Executes during object creation, after setting all properties.
function width_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to width_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_max_edit as text
%        str2double(get(hObject,'String')) returns contents of width_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.width_min_edit, 'String')))/str2num(get(handles.width_step_edit, 'String'));
set(handles.width_var_edit, 'String', num2str(Var));
update_Dimension_Variables(handles)


% --- Executes during object creation, after setting all properties.
function width_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to width_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_step_edit as text
%        str2double(get(hObject,'String')) returns contents of width_step_edit as a double

Var = 1 + (str2num(get(handles.width_max_edit, 'String')) -str2num(get(handles.width_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.width_var_edit, 'String', num2str(Var));
update_Dimension_Variables(handles)


% --- Executes during object creation, after setting all properties.
function width_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to width_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_var_edit as text
%        str2double(get(hObject,'String')) returns contents of width_var_edit as a double




% --- Executes during object creation, after setting all properties.
function width_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function segwidth_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to segwidth_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segwidth_min_edit as text
%        str2double(get(hObject,'String')) returns contents of segwidth_min_edit as a double

Var = 1 + (str2num(get(handles.segwidth_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.segwidth_step_edit, 'String'));
set(handles.segwidth_var_edit, 'String', num2str(Var));
update_Dimension_Variables(handles)


% --- Executes during object creation, after setting all properties.
function segwidth_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segwidth_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function segwidth_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to segwidth_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segwidth_max_edit as text
%        str2double(get(hObject,'String')) returns contents of segwidth_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.segwidth_min_edit, 'String')))/str2num(get(handles.segwidth_step_edit, 'String'));
set(handles.segwidth_var_edit, 'String', num2str(Var));
update_Dimension_Variables(handles)


% --- Executes during object creation, after setting all properties.
function segwidth_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segwidth_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function segwidth_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to segwidth_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segwidth_step_edit as text
%        str2double(get(hObject,'String')) returns contents of segwidth_step_edit as a double

Var = 1 + (str2num(get(handles.segwidth_max_edit, 'String')) -str2num(get(handles.segwidth_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.segwidth_var_edit, 'String', num2str(Var));
update_Dimension_Variables(handles)


% --- Executes during object creation, after setting all properties.
function segwidth_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segwidth_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function segwidth_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to segwidth_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segwidth_var_edit as text
%        str2double(get(hObject,'String')) returns contents of segwidth_var_edit as a double


% --- Executes during object creation, after setting all properties.
function segwidth_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segwidth_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gap_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gap_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gap_min_edit as text
%        str2double(get(hObject,'String')) returns contents of gap_min_edit as a double

Var = 1 + (str2num(get(handles.gap_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.gap_step_edit, 'String'));
set(handles.gap_var_edit, 'String', num2str(Var));
update_Dimension_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gap_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gap_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gap_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gap_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gap_max_edit as text
%        str2double(get(hObject,'String')) returns contents of gap_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.gap_min_edit, 'String')))/str2num(get(handles.gap_step_edit, 'String'));
set(handles.gap_var_edit, 'String', num2str(Var));
update_Dimension_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gap_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gap_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gap_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gap_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gap_step_edit as text
%        str2double(get(hObject,'String')) returns contents of gap_step_edit as a double

Var = 1 + (str2num(get(handles.gap_max_edit, 'String')) -str2num(get(handles.gap_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.gap_var_edit, 'String', num2str(Var));
update_Dimension_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gap_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gap_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gap_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gap_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gap_var_edit as text
%        str2double(get(hObject,'String')) returns contents of gap_var_edit as a double

%Find the number of variations



% --- Executes during object creation, after setting all properties.
function gap_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gap_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function update_Dimension_Variables(handles)
    TotalVar = str2num(get(handles.width_var_edit, 'String')) * str2num(get(handles.segwidth_var_edit, 'String')) *  str2num(get(handles.gap_var_edit, 'String'));
    str = strcat('Number of Variations:',num2str(TotalVar));
    set(handles.write_Dim_Var, 'String', str)
    
    update_Total_Variables(handles)

function update_Colour_Variables(handles)
    TotalVar = str2num(get(handles.digit_var_edit, 'String')) * str2num(get(handles.back_var_edit, 'String')) *  str2num(get(handles.invert_var_edit, 'String'));
    str = strcat('Number of Variations:', num2str(TotalVar));
    set(handles.write_Col_var, 'String', str)
    
    update_Total_Variables(handles)
    
function update_Distort_Variables(handles)
    TotalVar = str2num(get(handles.gaussblur_ker_var_edit, 'String')) * str2num(get(handles.gaussblur_sd_var_edit, 'String')) *  str2num(get(handles.angle_var_edit, 'String'))...
        * str2num(get(handles.slant_var_edit, 'String')) * str2num(get(handles.gaussnoise_mean_var_edit, 'String')) * str2num(get(handles.gaussnoise_var_var_edit, 'String'))...
        * str2num(get(handles.pixel_var_edit, 'String')) * str2num(get(handles.SaltPepp_var_edit, 'String'));
    str = strcat('Number of Variations:', num2str(TotalVar));
    set(handles.write_Dist_var, 'String', str)
    
    update_Total_Variables(handles)
    
function update_Total_Variables(handles)
    %Read in the 3 variations
    Dim = get(handles.write_Dim_Var, 'String');
    Dim = strsplit(Dim, ':');
    Dim = char(Dim(2));
    Dim = str2num(Dim);
    
    Col = get(handles.write_Col_var, 'String');
    Col = strsplit(Col, ':');
    Col = char(Col(2));
    Col = str2num(Col);
    
    Dist = get(handles.write_Dist_var, 'String');
    Dist = strsplit(Dist, ':');
    Dist = char(Dist(2));
    Dist = str2num(Dist);
    
    Dig = str2num(get(handles.digitselect_var_edit, 'String'));
    
    
    TotalVar = Dim * Col * Dist * Dig;
    set(handles.TotalVariations, 'String', num2str(TotalVar))
    
    

function write_Dim_Var_Callback(hObject, eventdata, handles)
% hObject    handle to write_Dim_Var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of write_Dim_Var as text
%        str2double(get(hObject,'String')) returns contents of write_Dim_Var as a double


% --- Executes during object creation, after setting all properties.
function write_Dim_Var_CreateFcn(hObject, eventdata, handles)
% hObject    handle to write_Dim_Var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function digit_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to digit_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digit_min_edit as text
%        str2double(get(hObject,'String')) returns contents of digit_min_edit as a double

Var = 1 + (str2num(get(handles.digit_min_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.digit_step_edit, 'String'));
set(handles.digit_var_edit, 'String', num2str(Var));

update_Colour_Variables(handles)


% --- Executes during object creation, after setting all properties.
function digit_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digit_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function digit_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to digit_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digit_max_edit as text
%        str2double(get(hObject,'String')) returns contents of digit_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.digit_min_edit, 'String')))/str2num(get(handles.digit_step_edit, 'String'));
set(handles.digit_var_edit, 'String', num2str(Var));

update_Colour_Variables(handles)


% --- Executes during object creation, after setting all properties.
function digit_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digit_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function digit_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to digit_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digit_step_edit as text
%        str2double(get(hObject,'String')) returns contents of digit_step_edit as a double

Var = 1 + (str2num(get(handles.digit_max_edit, 'String')) -str2num(get(handles.digit_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.digit_var_edit, 'String', num2str(Var));

update_Colour_Variables(handles)


% --- Executes during object creation, after setting all properties.
function digit_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digit_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function digit_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to digit_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digit_var_edit as text
%        str2double(get(hObject,'String')) returns contents of digit_var_edit as a double


% --- Executes during object creation, after setting all properties.
function digit_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digit_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function back_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to back_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of back_min_edit as text
%        str2double(get(hObject,'String')) returns contents of back_min_edit as a double

Var = 1 + (str2num(get(handles.back_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.back_step_edit, 'String'));
set(handles.back_var_edit, 'String', num2str(Var));

update_Colour_Variables(handles)



% --- Executes during object creation, after setting all properties.
function back_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to back_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function back_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to back_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of back_max_edit as text
%        str2double(get(hObject,'String')) returns contents of back_max_edit as a double
Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.back_min_edit, 'String')))/str2num(get(handles.back_step_edit, 'String'));
set(handles.back_var_edit, 'String', num2str(Var));

update_Colour_Variables(handles)



% --- Executes during object creation, after setting all properties.
function back_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to back_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function back_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to back_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of back_step_edit as text
%        str2double(get(hObject,'String')) returns contents of back_step_edit as a double
Var = 1 + (str2num(get(handles.back_max_edit, 'String')) -str2num(get(handles.back_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.back_var_edit, 'String', num2str(Var));

update_Colour_Variables(handles)




% --- Executes during object creation, after setting all properties.
function back_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to back_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function back_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to back_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of back_var_edit as text
%        str2double(get(hObject,'String')) returns contents of back_var_edit as a double


% --- Executes during object creation, after setting all properties.
function back_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to back_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function write_Col_var_Callback(hObject, eventdata, handles)
% hObject    handle to write_Col_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of write_Col_var as text
%        str2double(get(hObject,'String')) returns contents of write_Col_var as a double




% --- Executes during object creation, after setting all properties.
function write_Col_var_CreateFcn(hObject, eventdata, handles)
% hObject    handle to write_Col_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function invert_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to invert_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of invert_var_edit as text
%        str2double(get(hObject,'String')) returns contents of invert_var_edit as a double


% --- Executes during object creation, after setting all properties.
function invert_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to invert_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in invert_var_check.
function invert_var_check_Callback(hObject, eventdata, handles)
% hObject    handle to invert_var_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of invert_var_check

Var = 1+ get(hObject, 'Value');
set(handles.invert_var_edit, 'String', num2str(Var))

update_Colour_Variables(handles)


function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to invert_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to invert_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussblur_ker_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussblur_ker_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussblur_ker_min_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussblur_ker_min_edit as a double

Var = 1 + (str2num(get(handles.gaussblur_ker_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.gaussblur_ker_step_edit, 'String'));
set(handles.gaussblur_ker_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gaussblur_ker_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussblur_ker_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussblur_ker_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussblur_ker_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussblur_ker_max_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussblur_ker_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.gaussblur_ker_min_edit, 'String')))/str2num(get(handles.gaussblur_ker_step_edit, 'String'));
set(handles.gaussblur_ker_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gaussblur_ker_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussblur_ker_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussblur_ker_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussblur_ker_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussblur_ker_step_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussblur_ker_step_edit as a double

Var = 1 + (str2num(get(handles.gaussblur_ker_max_edit, 'String')) -str2num(get(handles.gaussblur_ker_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.gaussblur_ker_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gaussblur_ker_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussblur_ker_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussblur_ker_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussblur_ker_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussblur_ker_var_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussblur_ker_var_edit as a double



% --- Executes during object creation, after setting all properties.
function gaussblur_ker_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussblur_ker_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angle_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to angle_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_min_edit as text
%        str2double(get(hObject,'String')) returns contents of angle_min_edit as a double

Var = 1 + (str2num(get(handles.angle_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.angle_step_edit, 'String'));
set(handles.angle_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)

% --- Executes during object creation, after setting all properties.
function angle_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angle_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to angle_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_max_edit as text
%        str2double(get(hObject,'String')) returns contents of angle_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.angle_min_edit, 'String')))/str2num(get(handles.angle_step_edit, 'String'));
set(handles.angle_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function angle_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angle_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to angle_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_step_edit as text
%        str2double(get(hObject,'String')) returns contents of angle_step_edit as a double

Var = 1 + (str2num(get(handles.angle_max_edit, 'String')) -str2num(get(handles.angle_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.angle_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function angle_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angle_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to angle_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_var_edit as text
%        str2double(get(hObject,'String')) returns contents of angle_var_edit as a double


% --- Executes during object creation, after setting all properties.
function angle_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussnoise_mean_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussnoise_mean_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussnoise_mean_min_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussnoise_mean_min_edit as a double

Var = 1 + (str2num(get(handles.gaussnoise_mean_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.gaussnoise_mean_step_edit, 'String'));
set(handles.angle_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gaussnoise_mean_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussnoise_mean_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussnoise_mean_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussnoise_mean_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussnoise_mean_max_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussnoise_mean_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.gaussnoise_mean_min_edit, 'String')))/str2num(get(handles.gaussnoise_mean_step_edit, 'String'));
set(handles.angle_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gaussnoise_mean_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussnoise_mean_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussnoise_mean_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussnoise_mean_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussnoise_mean_step_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussnoise_mean_step_edit as a double

Var = 1 + (str2num(get(handles.gaussnoise_mean_max_edit, 'String')) -str2num(get(handles.gaussnoise_mean_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.angle_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gaussnoise_mean_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussnoise_mean_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussnoise_mean_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussnoise_mean_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussnoise_mean_var_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussnoise_mean_var_edit as a double



% --- Executes during object creation, after setting all properties.
function gaussnoise_mean_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussnoise_mean_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixel_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_min_edit as text
%        str2double(get(hObject,'String')) returns contents of pixel_min_edit as a double

Var = 1 + (str2num(get(handles.pixel_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.pixel_step_edit, 'String'));
set(handles.pixel_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)



% --- Executes during object creation, after setting all properties.
function pixel_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixel_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_max_edit as text
%        str2double(get(hObject,'String')) returns contents of pixel_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.pixel_min_edit, 'String')))/str2num(get(handles.pixel_step_edit, 'String'));
set(handles.pixel_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function pixel_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixel_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_step_edit as text
%        str2double(get(hObject,'String')) returns contents of pixel_step_edit as a double

Var = 1 + (str2num(get(handles.pixel_max_edit, 'String')) -str2num(get(handles.pixel_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.pixel_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function pixel_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pixel_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_var_edit as text
%        str2double(get(hObject,'String')) returns contents of pixel_var_edit as a double



% --- Executes during object creation, after setting all properties.
function pixel_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussblur_sd_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussblur_sd_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussblur_sd_min_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussblur_sd_min_edit as a double

Var = 1 + (str2num(get(handles.gaussblur_sd_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.gaussblur_sd_step_edit, 'String'));
set(handles.gaussblur_sd_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)



% --- Executes during object creation, after setting all properties.
function gaussblur_sd_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussblur_sd_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussblur_sd_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussblur_sd_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussblur_sd_max_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussblur_sd_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.gaussblur_sd_min_edit, 'String')))/str2num(get(handles.gaussblur_sd_step_edit, 'String'));
set(handles.gaussblur_sd_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gaussblur_sd_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussblur_sd_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussblur_sd_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussblur_sd_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussblur_sd_step_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussblur_sd_step_edit as a double

Var = 1 + (str2num(get(handles.gaussblur_sd_max_edit, 'String')) -str2num(get(handles.gaussblur_sd_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.gaussblur_sd_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)

% --- Executes during object creation, after setting all properties.
function gaussblur_sd_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussblur_sd_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussblur_sd_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussblur_sd_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussblur_sd_var_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussblur_sd_var_edit as a double


% --- Executes during object creation, after setting all properties.
function gaussblur_sd_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussblur_sd_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slant_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to slant_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slant_min_edit as text
%        str2double(get(hObject,'String')) returns contents of slant_min_edit as a double

Var = 1 + (str2num(get(handles.slant_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.slant_step_edit, 'String'));
set(handles.slant_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function slant_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slant_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slant_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to slant_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slant_max_edit as text
%        str2double(get(hObject,'String')) returns contents of slant_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.slant_min_edit, 'String')))/str2num(get(handles.slant_step_edit, 'String'));
set(handles.slant_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function slant_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slant_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slant_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to slant_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slant_step_edit as text
%        str2double(get(hObject,'String')) returns contents of slant_step_edit as a double

Var = 1 + (str2num(get(handles.slant_max_edit, 'String')) -str2num(get(handles.slant_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.slant_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function slant_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slant_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slant_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to slant_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slant_var_edit as text
%        str2double(get(hObject,'String')) returns contents of slant_var_edit as a double


% --- Executes during object creation, after setting all properties.
function slant_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slant_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussnoise_var_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussnoise_var_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussnoise_var_min_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussnoise_var_min_edit as a double

Var = 1 + (str2num(get(handles.gaussnoise_var_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.gaussnoise_var_step_edit, 'String'));
set(handles.gaussnoise_var_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gaussnoise_var_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussnoise_var_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussnoise_var_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussnoise_var_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussnoise_var_max_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussnoise_var_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.gaussnoise_var_min_edit, 'String')))/str2num(get(handles.gaussnoise_var_step_edit, 'String'));
set(handles.gaussnoise_var_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function gaussnoise_var_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussnoise_var_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussnoise_var_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussnoise_var_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussnoise_var_step_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussnoise_var_step_edit as a double

Var = 1 + (str2num(get(handles.gaussnoise_var_max_edit, 'String')) -str2num(get(handles.gaussnoise_var_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.gaussnoise_var_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)



% --- Executes during object creation, after setting all properties.
function gaussnoise_var_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussnoise_var_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussnoise_var_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gaussnoise_var_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussnoise_var_var_edit as text
%        str2double(get(hObject,'String')) returns contents of gaussnoise_var_var_edit as a double



% --- Executes during object creation, after setting all properties.
function gaussnoise_var_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussnoise_var_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SaltPepp_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to SaltPepp_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SaltPepp_min_edit as text
%        str2double(get(hObject,'String')) returns contents of SaltPepp_min_edit as a double

Var = 1 + (str2num(get(handles.SaltPepp_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.SaltPepp_step_edit, 'String'));
set(handles.SaltPepp_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function SaltPepp_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaltPepp_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SaltPepp_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to SaltPepp_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SaltPepp_max_edit as text
%        str2double(get(hObject,'String')) returns contents of SaltPepp_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.SaltPepp_min_edit, 'String')))/str2num(get(handles.SaltPepp_step_edit, 'String'));
set(handles.SaltPepp_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function SaltPepp_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaltPepp_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SaltPepp_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to SaltPepp_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SaltPepp_step_edit as text
%        str2double(get(hObject,'String')) returns contents of SaltPepp_step_edit as a double

Var = 1 + (str2num(get(handles.SaltPepp_max_edit, 'String')) -str2num(get(handles.SaltPepp_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.SaltPepp_var_edit, 'String', num2str(Var));

update_Distort_Variables(handles)


% --- Executes during object creation, after setting all properties.
function SaltPepp_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaltPepp_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SaltPepp_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to SaltPepp_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SaltPepp_var_edit as text
%        str2double(get(hObject,'String')) returns contents of SaltPepp_var_edit as a double


% --- Executes during object creation, after setting all properties.
function SaltPepp_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaltPepp_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function write_Dist_var_Callback(hObject, eventdata, handles)
% hObject    handle to write_Dist_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of write_Dist_var as text
%        str2double(get(hObject,'String')) returns contents of write_Dist_var as a double


% --- Executes during object creation, after setting all properties.
function write_Dist_var_CreateFcn(hObject, eventdata, handles)
% hObject    handle to write_Dist_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TotalVariations_Callback(hObject, eventdata, handles)
% hObject    handle to TotalVariations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TotalVariations as text
%        str2double(get(hObject,'String')) returns contents of TotalVariations as a double


% --- Executes during object creation, after setting all properties.
function TotalVariations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotalVariations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Fill Min, Max, Step and SaveLoc
SaveLoc = get(handles.saveloc_edit, 'String');

%If the last entry of the SaveLocation is not / then add it
if ~strcmp(SaveLoc(end), '/')
    SaveLoc = strcat(SaveLoc, '/');
end

Min.DigitWidth = str2num(get(handles.width_min_edit, 'String'));
Max.DigitWidth = str2num(get(handles.width_max_edit, 'String'));
Step.DigitWidth = str2num(get(handles.width_step_edit, 'String'));

Min.SegmentWidth = str2num(get(handles.segwidth_min_edit, 'String'));
Max.SegmentWidth = str2num(get(handles.segwidth_max_edit, 'String'));
Step.SegmentWidth = str2num(get(handles.segwidth_step_edit, 'String'));

Min.SegmentGap = str2num(get(handles.gap_min_edit, 'String'));
Max.SegmentGap = str2num(get(handles.gap_max_edit, 'String'));
Step.SegmentGap = str2num(get(handles.gap_step_edit, 'String'));

Min.Angle = str2num(get(handles.angle_min_edit, 'String'));
Max.Angle = str2num(get(handles.angle_max_edit, 'String'));
Step.Angle = str2num(get(handles.angle_step_edit, 'String'));

Min.Slant = str2num(get(handles.slant_min_edit, 'String'));
Max.Slant = str2num(get(handles.slant_max_edit, 'String'));
Step.Slant = str2num(get(handles.slant_step_edit, 'String'));

Min.DigitGray = str2num(get(handles.digit_min_edit, 'String'));
Max.DigitGray = str2num(get(handles.digit_max_edit, 'String'));
Step.DigitGray = str2num(get(handles.digit_step_edit, 'String'));

Min.BackGray = str2num(get(handles.back_min_edit, 'String'));
Max.BackGray = str2num(get(handles.back_max_edit, 'String'));
Step.BackGray = str2num(get(handles.back_step_edit, 'String'));

Min.Invert = 0;
Max.Invert = get(handles.invert_var_check, 'Value');
Step.Invert = 1;

Min.Pixelation = str2num(get(handles.pixel_min_edit, 'String'));
Max.Pixelation = str2num(get(handles.pixel_max_edit, 'String'));
Step.Pixelation = str2num(get(handles.pixel_step_edit, 'String'));

Min.GaussNoise = str2num(get(handles.gaussnoise_var_min_edit, 'String'));
Max.GaussNoise = str2num(get(handles.gaussnoise_var_max_edit, 'String'));
Step.GaussNoise = str2num(get(handles.gaussnoise_var_step_edit, 'String'));

Min.SaltPepper = str2num(get(handles.SaltPepp_min_edit, 'String'));
Max.SaltPepper = str2num(get(handles.SaltPepp_max_edit, 'String'));
Step.SaltPepper = str2num(get(handles.SaltPepp_step_edit, 'String'));

Min.GaussSize = str2num(get(handles.gaussblur_ker_min_edit, 'String'));
Max.GaussSize = str2num(get(handles.gaussblur_ker_max_edit, 'String'));
Step.GaussSize = str2num(get(handles.gaussblur_ker_step_edit, 'String'));

Min.GaussVar = str2num(get(handles.gaussblur_sd_min_edit, 'String'));
Max.GaussVar = str2num(get(handles.gaussblur_sd_max_edit, 'String'));
Step.GaussVar = str2num(get(handles.gaussblur_sd_step_edit, 'String'));

Min.Digit = str2num(get(handles.digitselect_min_edit, 'String'));
Max.Digit = str2num(get(handles.digitselect_max_edit, 'String'));
Step.Digit = str2num(get(handles.digitselect_step_edit, 'String'));

set(handles.savebutton, 'Visible', 'off')

Save( SaveLoc, Min, Max, Step )

set(handles.savebutton, 'Visible', 'on')



function saveloc_edit_Callback(hObject, eventdata, handles)
% hObject    handle to saveloc_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of saveloc_edit as text
%        str2double(get(hObject,'String')) returns contents of saveloc_edit as a double


% --- Executes during object creation, after setting all properties.
function saveloc_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saveloc_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text5.
function text5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function digitselect_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to digitselect_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digitselect_min_edit as text
%        str2double(get(hObject,'String')) returns contents of digitselect_min_edit as a double

Var = 1 + (str2num(get(handles.digitselect_max_edit, 'String')) -str2num(get(hObject, 'String')))/str2num(get(handles.digitselect_step_edit, 'String'));
set(handles.digitselect_var_edit, 'String', num2str(Var));

update_Total_Variables(handles)


% --- Executes during object creation, after setting all properties.
function digitselect_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digitselect_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function digitselect_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to digitselect_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digitselect_max_edit as text
%        str2double(get(hObject,'String')) returns contents of digitselect_max_edit as a double

Var = 1 + (str2num(get(hObject, 'String')) -str2num(get(handles.digitselect_min_edit, 'String')))/str2num(get(handles.digitselect_step_edit, 'String'));
set(handles.digitselect_var_edit, 'String', num2str(Var));

update_Total_Variables(handles)


% --- Executes during object creation, after setting all properties.
function digitselect_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digitselect_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function digitselect_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to digitselect_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digitselect_step_edit as text
%        str2double(get(hObject,'String')) returns contents of digitselect_step_edit as a double

Var = 1 + (str2num(get(handles.digitselect_max_edit, 'String')) -str2num(get(handles.digitselect_min_edit, 'String')))/str2num(get(hObject, 'String'));
set(handles.digitselect_var_edit, 'String', num2str(Var));

update_Total_Variables(handles)


% --- Executes during object creation, after setting all properties.
function digitselect_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digitselect_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function digitselect_var_edit_Callback(hObject, eventdata, handles)
% hObject    handle to digitselect_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digitselect_var_edit as text
%        str2double(get(hObject,'String')) returns contents of digitselect_var_edit as a double


% --- Executes during object creation, after setting all properties.
function digitselect_var_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digitselect_var_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function largedataset(hObject, eventdata, handles)
    set(handles.width_min_edit, 'String', '19')
    set(handles.width_max_edit, 'String', '43')
    set(handles.width_step_edit, 'String', '2')    
    set(handles.width_var_edit, 'String', '13')
    set(handles.segwidth_min_edit, 'String', '5')
    set(handles.segwidth_max_edit, 'String', '11')
    set(handles.segwidth_step_edit, 'String', '1')
    set(handles.segwidth_var_edit, 'String', '7')
    set(handles.gap_min_edit, 'String', '0')
    set(handles.gap_max_edit, 'String', '3')
    set(handles.gap_step_edit, 'String', '1')
    set(handles.gap_var_edit, 'String', '4')
    
    set(handles.digit_min_edit, 'String', '0')
    set(handles.digit_max_edit, 'String', '0.4')
    set(handles.digit_step_edit, 'String', '0.2')
    set(handles.digit_var_edit, 'String', '3')
    set(handles.back_min_edit, 'String', '0.6')
    set(handles.back_max_edit, 'String', '1')
    set(handles.back_step_edit, 'String', '0.2')
    set(handles.back_var_edit, 'String', '3')
    set(handles.invert_var_check, 'Value', 1)
    set(handles.invert_var_edit, 'String', '2')
    
    set(handles.gaussblur_ker_min_edit, 'String', '1')
    set(handles.gaussblur_ker_max_edit, 'String', '3')
    set(handles.gaussblur_ker_step_edit, 'String', '1')
    set(handles.gaussblur_ker_var_edit, 'String', '3')
    set(handles.gaussblur_sd_min_edit, 'String', '1')
    set(handles.gaussblur_sd_max_edit, 'String', '3')
    set(handles.gaussblur_sd_step_edit, 'String', '1')
    set(handles.gaussblur_sd_var_edit, 'String', '3')
    set(handles.angle_min_edit, 'String', '-20')
    set(handles.angle_max_edit, 'String', '20')
    set(handles.angle_step_edit, 'String', '2')
    set(handles.angle_var_edit, 'String', '21')
    set(handles.slant_min_edit, 'String', '-0.4')
    set(handles.slant_max_edit, 'String', '0.4')
    set(handles.slant_step_edit, 'String', '0.2')
    set(handles.slant_var_edit, 'String', '5')
    set(handles.gaussnoise_mean_min_edit, 'String', '0')
    set(handles.gaussnoise_mean_max_edit, 'String', '0')
    set(handles.gaussnoise_mean_step_edit, 'String', '1')
    set(handles.gaussnoise_mean_var_edit, 'String', '1')
    set(handles.gaussnoise_var_min_edit, 'String', '0')
    set(handles.gaussnoise_var_max_edit, 'String', '0.01')
    set(handles.gaussnoise_var_step_edit, 'String', '0.002')
    set(handles.gaussnoise_var_var_edit, 'String', '6')
    set(handles.pixel_min_edit, 'String', '1')
    set(handles.pixel_max_edit, 'String', '3')
    set(handles.pixel_step_edit, 'String', '1')
    set(handles.pixel_var_edit, 'String', '3')
    set(handles.SaltPepp_min_edit, 'String', '0')
    set(handles.SaltPepp_max_edit, 'String', '0.01')
    set(handles.SaltPepp_step_edit, 'String', '0.002')
    set(handles.SaltPepp_var_edit, 'String', '6')
    
    set(handles.digitselect_min_edit, 'String', '0')
    set(handles.digitselect_max_edit, 'String', '9')
    set(handles.digitselect_step_edit, 'String', '1')
    set(handles.digitselect_var_edit, 'String', '10')
    
    
    update_Dimension_Variables(handles)
    update_Colour_Variables(handles)
    update_Distort_Variables(handles)
    
function mediumdataset(hObject, eventdata, handles)
    set(handles.width_min_edit, 'String', '19')
    set(handles.width_max_edit, 'String', '43')
    set(handles.width_step_edit, 'String', '12')    
    set(handles.width_var_edit, 'String', '3')
    set(handles.segwidth_min_edit, 'String', '5')
    set(handles.segwidth_max_edit, 'String', '11')
    set(handles.segwidth_step_edit, 'String', '3')
    set(handles.segwidth_var_edit, 'String', '3')
    set(handles.gap_min_edit, 'String', '0')
    set(handles.gap_max_edit, 'String', '3')
    set(handles.gap_step_edit, 'String', '3')
    set(handles.gap_var_edit, 'String', '2')
    
    set(handles.digit_min_edit, 'String', '0')
    set(handles.digit_max_edit, 'String', '0.4')
    set(handles.digit_step_edit, 'String', '0.2')
    set(handles.digit_var_edit, 'String', '3')
    set(handles.back_min_edit, 'String', '0.6')
    set(handles.back_max_edit, 'String', '1')
    set(handles.back_step_edit, 'String', '0.2')
    set(handles.back_var_edit, 'String', '3')
    set(handles.invert_var_check, 'Value', 1)
    set(handles.invert_var_edit, 'String', '2')
    
    set(handles.gaussblur_ker_min_edit, 'String', '1')
    set(handles.gaussblur_ker_max_edit, 'String', '3')
    set(handles.gaussblur_ker_step_edit, 'String', '2')
    set(handles.gaussblur_ker_var_edit, 'String', '2')
    set(handles.gaussblur_sd_min_edit, 'String', '1')
    set(handles.gaussblur_sd_max_edit, 'String', '3')
    set(handles.gaussblur_sd_step_edit, 'String', '2')
    set(handles.gaussblur_sd_var_edit, 'String', '2')
    set(handles.angle_min_edit, 'String', '-20')
    set(handles.angle_max_edit, 'String', '20')
    set(handles.angle_step_edit, 'String', '20')
    set(handles.angle_var_edit, 'String', '3')
    set(handles.slant_min_edit, 'String', '-0.4')
    set(handles.slant_max_edit, 'String', '0.4')
    set(handles.slant_step_edit, 'String', '0.4')
    set(handles.slant_var_edit, 'String', '3')
    set(handles.gaussnoise_mean_min_edit, 'String', '0')
    set(handles.gaussnoise_mean_max_edit, 'String', '0')
    set(handles.gaussnoise_mean_step_edit, 'String', '1')
    set(handles.gaussnoise_mean_var_edit, 'String', '1')
    set(handles.gaussnoise_var_min_edit, 'String', '0')
    set(handles.gaussnoise_var_max_edit, 'String', '0.01')
    set(handles.gaussnoise_var_step_edit, 'String', '0.01')
    set(handles.gaussnoise_var_var_edit, 'String', '2')
    set(handles.pixel_min_edit, 'String', '1')
    set(handles.pixel_max_edit, 'String', '3')
    set(handles.pixel_step_edit, 'String', '2')
    set(handles.pixel_var_edit, 'String', '2')
    set(handles.SaltPepp_min_edit, 'String', '0')
    set(handles.SaltPepp_max_edit, 'String', '0.01')
    set(handles.SaltPepp_step_edit, 'String', '0.01')
    set(handles.SaltPepp_var_edit, 'String', '2')
    
    set(handles.digitselect_min_edit, 'String', '0')
    set(handles.digitselect_max_edit, 'String', '9')
    set(handles.digitselect_step_edit, 'String', '1')
    set(handles.digitselect_var_edit, 'String', '10')
    
    
    update_Dimension_Variables(handles)
    update_Colour_Variables(handles)
    update_Distort_Variables(handles)
    
function smalldataset(hObject, eventdata, handles)
    set(handles.width_min_edit, 'String', '19')
    set(handles.width_max_edit, 'String', '43')
    set(handles.width_step_edit, 'String', '12')    
    set(handles.width_var_edit, 'String', '3')
    set(handles.segwidth_min_edit, 'String', '5')
    set(handles.segwidth_max_edit, 'String', '11')
    set(handles.segwidth_step_edit, 'String', '6')
    set(handles.segwidth_var_edit, 'String', '2')
    set(handles.gap_min_edit, 'String', '0')
    set(handles.gap_max_edit, 'String', '3')
    set(handles.gap_step_edit, 'String', '3')
    set(handles.gap_var_edit, 'String', '2')
    
    set(handles.digit_min_edit, 'String', '0')
    set(handles.digit_max_edit, 'String', '0.2')
    set(handles.digit_step_edit, 'String', '0.2')
    set(handles.digit_var_edit, 'String', '2')
    set(handles.back_min_edit, 'String', '0.8')
    set(handles.back_max_edit, 'String', '1')
    set(handles.back_step_edit, 'String', '0.2')
    set(handles.back_var_edit, 'String', '2')
    set(handles.invert_var_check, 'Value', 1)
    set(handles.invert_var_edit, 'String', '2')
    
    set(handles.gaussblur_ker_min_edit, 'String', '1')
    set(handles.gaussblur_ker_max_edit, 'String', '3')
    set(handles.gaussblur_ker_step_edit, 'String', '2')
    set(handles.gaussblur_ker_var_edit, 'String', '2')
    set(handles.gaussblur_sd_min_edit, 'String', '1')
    set(handles.gaussblur_sd_max_edit, 'String', '1')
    set(handles.gaussblur_sd_step_edit, 'String', '2')
    set(handles.gaussblur_sd_var_edit, 'String', '1')
    set(handles.angle_min_edit, 'String', '-10')
    set(handles.angle_max_edit, 'String', '10')
    set(handles.angle_step_edit, 'String', '10')
    set(handles.angle_var_edit, 'String', '3')
    set(handles.slant_min_edit, 'String', '-0.4')
    set(handles.slant_max_edit, 'String', '0.4')
    set(handles.slant_step_edit, 'String', '0.4')
    set(handles.slant_var_edit, 'String', '3')
    set(handles.gaussnoise_mean_min_edit, 'String', '0')
    set(handles.gaussnoise_mean_max_edit, 'String', '0')
    set(handles.gaussnoise_mean_step_edit, 'String', '1')
    set(handles.gaussnoise_mean_var_edit, 'String', '1')
    set(handles.gaussnoise_var_min_edit, 'String', '0')
    set(handles.gaussnoise_var_max_edit, 'String', '0.01')
    set(handles.gaussnoise_var_step_edit, 'String', '0.01')
    set(handles.gaussnoise_var_var_edit, 'String', '2')
    set(handles.pixel_min_edit, 'String', '1')
    set(handles.pixel_max_edit, 'String', '3')
    set(handles.pixel_step_edit, 'String', '2')
    set(handles.pixel_var_edit, 'String', '2')
    set(handles.SaltPepp_min_edit, 'String', '0')
    set(handles.SaltPepp_max_edit, 'String', '0.01')
    set(handles.SaltPepp_step_edit, 'String', '0.01')
    set(handles.SaltPepp_var_edit, 'String', '2')
    
    set(handles.digitselect_min_edit, 'String', '0')
    set(handles.digitselect_max_edit, 'String', '9')
    set(handles.digitselect_step_edit, 'String', '1')
    set(handles.digitselect_var_edit, 'String', '10')
    
    
    update_Dimension_Variables(handles)
    update_Colour_Variables(handles)
    update_Distort_Variables(handles)
    
function binarysmalldataset(hObject, eventdata, handles)
    set(handles.width_min_edit, 'String', '19')
    set(handles.width_max_edit, 'String', '31')
    set(handles.width_step_edit, 'String', '12')    
    set(handles.width_var_edit, 'String', '2')
    set(handles.segwidth_min_edit, 'String', '5')
    set(handles.segwidth_max_edit, 'String', '11')
    set(handles.segwidth_step_edit, 'String', '6')
    set(handles.segwidth_var_edit, 'String', '2')
    set(handles.gap_min_edit, 'String', '0')
    set(handles.gap_max_edit, 'String', '3')
    set(handles.gap_step_edit, 'String', '3')
    set(handles.gap_var_edit, 'String', '2')
    
    set(handles.digit_min_edit, 'String', '0')
    set(handles.digit_max_edit, 'String', '0')
    set(handles.digit_step_edit, 'String', '1')
    set(handles.digit_var_edit, 'String', '1')
    set(handles.back_min_edit, 'String', '1')
    set(handles.back_max_edit, 'String', '1')
    set(handles.back_step_edit, 'String', '0.2')
    set(handles.back_var_edit, 'String', '1')
    set(handles.invert_var_check, 'Value', 0)
    set(handles.invert_var_edit, 'String', '1')
    
    set(handles.gaussblur_ker_min_edit, 'String', '1')
    set(handles.gaussblur_ker_max_edit, 'String', '3')
    set(handles.gaussblur_ker_step_edit, 'String', '2')
    set(handles.gaussblur_ker_var_edit, 'String', '2')
    set(handles.gaussblur_sd_min_edit, 'String', '1')
    set(handles.gaussblur_sd_max_edit, 'String', '1')
    set(handles.gaussblur_sd_step_edit, 'String', '2')
    set(handles.gaussblur_sd_var_edit, 'String', '1')
    set(handles.angle_min_edit, 'String', '-10')
    set(handles.angle_max_edit, 'String', '10')
    set(handles.angle_step_edit, 'String', '10')
    set(handles.angle_var_edit, 'String', '3')
    set(handles.slant_min_edit, 'String', '-0.4')
    set(handles.slant_max_edit, 'String', '0.4')
    set(handles.slant_step_edit, 'String', '0.4')
    set(handles.slant_var_edit, 'String', '3')
    set(handles.gaussnoise_mean_min_edit, 'String', '0')
    set(handles.gaussnoise_mean_max_edit, 'String', '0')
    set(handles.gaussnoise_mean_step_edit, 'String', '1')
    set(handles.gaussnoise_mean_var_edit, 'String', '1')
    set(handles.gaussnoise_var_min_edit, 'String', '0')
    set(handles.gaussnoise_var_max_edit, 'String', '0.01')
    set(handles.gaussnoise_var_step_edit, 'String', '0.01')
    set(handles.gaussnoise_var_var_edit, 'String', '2')
    set(handles.pixel_min_edit, 'String', '1')
    set(handles.pixel_max_edit, 'String', '3')
    set(handles.pixel_step_edit, 'String', '2')
    set(handles.pixel_var_edit, 'String', '2')
    set(handles.SaltPepp_min_edit, 'String', '0')
    set(handles.SaltPepp_max_edit, 'String', '0.01')
    set(handles.SaltPepp_step_edit, 'String', '0.005')
    set(handles.SaltPepp_var_edit, 'String', '3')
    
    set(handles.digitselect_min_edit, 'String', '0')
    set(handles.digitselect_max_edit, 'String', '9')
    set(handles.digitselect_step_edit, 'String', '1')
    set(handles.digitselect_var_edit, 'String', '10')
    
    
    update_Dimension_Variables(handles)
    update_Colour_Variables(handles)
    update_Distort_Variables(handles)
    
    
function updatevariations(h1, h2, h3, h4, handles)
    
    Var = 1 + (str2num(get(h2, 'String')) -str2num(get(h1, 'String')))/str2num(get(h3, 'String'));
    set(h4, 'String', num2str(Var));

    update_Distort_Variables(handles) 
    

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
Val = get(hObject, 'Value');
if Val == 1
    largedataset(hObject, eventdata, handles)
elseif Val == 2
    mediumdataset(hObject, eventdata, handles)
elseif Val ==3
    smalldataset(hObject, eventdata, handles)
elseif Val ==4
    binarysmalldataset(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
