function varargout = DigitalImgProcess(varargin)
% DIGITALIMGPROCESS MATLAB code for DigitalImgProcess.fig
%      DIGITALIMGPROCESS, by itself, creates a new DIGITALIMGPROCESS or raises the existing
%      singleton*.
%
%      H = DIGITALIMGPROCESS returns the handle to a new DIGITALIMGPROCESS or the handle to
%      the existing singleton*.
%
%      DIGITALIMGPROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIGITALIMGPROCESS.M with the given input arguments.
%
%      DIGITALIMGPROCESS('Property','Value',...) creates a new DIGITALIMGPROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DigitalImgProcess_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DigitalImgProcess_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DigitalImgProcess

% Last Modified by GUIDE v2.5 28-Mar-2016 01:15:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DigitalImgProcess_OpeningFcn, ...
                   'gui_OutputFcn',  @DigitalImgProcess_OutputFcn, ...
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

end
% --- Executes just before DigitalImgProcess is made visible.

function DigitalImgProcess_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DigitalImgProcess (see VARARGIN)

% Choose default command line output for DigitalImgProcess
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DigitalImgProcess wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end
% --- Outputs from this function are returned to the command line.

function varargout = DigitalImgProcess_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure

varargout{1} = handles.output; 
end





% --- Executes on button press in LoadImg.
function LoadImg_Callback(hObject, ~, handles)
% hObject    handle to LoadImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[image_file,pathname] = uigetfile('*.*');
if ~isempty(image_file)
addpath(pathname);
handles.im_original=imread(image_file);
handles.FinalImg=handles.im_original;
handles.sttable=handles.im_original(:,:,1);
handles.ndtable=handles.im_original(:,:,2);
handles.rdtable=handles.im_original(:,:,3);
info=imfinfo(image_file);
handles.depth=info.BitDepth/3;
handles.maxdepth=((2^handles.depth)/2)-5;
x=size(handles.sttable); 
handles.x=(1:x(1,2));

set(handles.rgb,'HandleVisibility','ON');
axes(handles.rgb);
plot(handles.x,handles.sttable(1,:),'r');
hold on
plot(handles.x,handles.ndtable(1,:),'g'); 
plot(handles.x,handles.rdtable(1,:),'b'); 
hold off;
set(handles.rgb,'HandleVisibility','OFF');

set(handles.newrgb,'HandleVisibility','ON');
axes(handles.newrgb);
plot(handles.x,handles.sttable(1,:),'r');
hold on
plot(handles.x,handles.ndtable(1,:),'g'); 
plot(handles.x,handles.rdtable(1,:),'b'); 
hold off;
set(handles.newrgb,'HandleVisibility','OFF');


set(handles.ImgOriginal,'HandleVisibility','ON');
axes(handles.ImgOriginal);
image(handles.im_original);
axis equal;
axis tight;
axis off;
set(handles.ImgOriginal,'HandleVisibility','OFF');

set(handles.NewImg,'HandleVisibility','ON');
axes(handles.NewImg);
image(handles.FinalImg);
axis equal;
axis tight;
axis off;
set(handles.NewImg,'HandleVisibility','OFF');

guidata(hObject, handles);
end
end


% --- Executes on button press in Go.
function Go_Callback(hObject, eventdata, handles)
% hObject    handle to Go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  
handles.FinalImg=cat(3,handles.sttable,handles.ndtable,handles.rdtable);

set(handles.NewImg,'HandleVisibility','ON');
axes(handles.NewImg);
image(handles.FinalImg);
axis equal;
axis tight;
axis off;
set(handles.NewImg,'HandleVisibility','OFF');
guidata(hObject, handles);



end


function B1_Callback(hObject, eventdata, handles)
% hObject    handle to B1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B1 as text
%        str2double(get(hObject,'String')) returns contents of B1 as a double
b1=get(handles.B1,'String');
handles.Bb1=str2num(b1);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
end
function B1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


end


function G1_Callback(hObject, eventdata, handles)
% hObject    handle to G1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of G1 as text
%        str2double(get(hObject,'String')) returns contents of G1 as a double

g1=get(handles.G1,'String');
handles.Gg1=str2num(g1);
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
end
function G1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function R1_Callback(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r1=get(handles.R1,'String');
handles.Rr1=str2num(r1);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of R1 as text
%        str2double(get(hObject,'String')) returns contents of R1 as a double


% --- Executes during object creation, after setting all properties.
end
function R1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function B2_Callback(hObject, eventdata, handles)
% hObject    handle to B2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B2 as text
%        str2double(get(hObject,'String')) returns contents of B2 as a double
b2=get(handles.B2,'String');
handles.Bb2=str2num(b2);
w=round((handles.maxdepth*handles.widthy)/100);
for i=-w:w
    handles.rdtable(handles.rdtable==(handles.Bb1+i))=(handles.Bb2+i);
end

set(handles.Third,'HandleVisibility','ON');
axes(handles.Third);
imshow(handles.rdtable);
axis equal;
axis tight;
axis off;
set(handles.Third,'HandleVisibility','OFF');
guidata(hObject, handles);


set(handles.newrgb,'HandleVisibility','ON');
axes(handles.newrgb);
plot(handles.x,handles.sttable(1,:),'r');
hold on
plot(handles.x,handles.ndtable(1,:),'g'); 
plot(handles.x,handles.rdtable(1,:),'b'); 
hold off;
set(handles.newrgb,'HandleVisibility','OFF');

end
function B2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function G2_Callback(hObject, eventdata, handles)
% hObject    handle to G2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of G2 as text
%        str2double(get(hObject,'String')) returns contents of G2 as a double
g2=get(handles.G2,'String');
handles.Gg2=str2num(g2);
w=round((handles.maxdepth*handles.widthy)/100);
for i=-w:w
    handles.ndtable(handles.ndtable==(handles.Gg1+i))=(handles.Gg2+i);
end
guidata(hObject, handles);

set(handles.Second,'HandleVisibility','ON');
axes(handles.Second);
imshow(handles.ndtable);
axis equal;
axis tight;
axis off;
set(handles.Second,'HandleVisibility','OFF');

set(handles.newrgb,'HandleVisibility','ON');
axes(handles.newrgb);
plot(handles.x,handles.sttable(1,:),'r');
hold on
plot(handles.x,handles.ndtable(1,:),'g'); 
plot(handles.x,handles.rdtable(1,:),'b'); 
hold off;
set(handles.newrgb,'HandleVisibility','OFF');

% --- Executes during object creation, after setting all properties.
end
function G2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function R2_Callback(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R2 as text
%        str2double(get(hObject,'String')) returns contents of R2 as a double

r2=get(handles.R2,'String');
handles.Rr2=str2num(r2);
w=round((handles.maxdepth*handles.widthy)/100);
for i=-w:w
    handles.sttable(handles.sttable==(handles.Rr1+i))=(handles.Rr2+i);
end

set(handles.First,'HandleVisibility','ON');
axes(handles.First);
imshow(handles.sttable);
axis equal;
axis tight;
axis off;
set(handles.First,'HandleVisibility','OFF');

set(handles.newrgb,'HandleVisibility','ON');
axes(handles.newrgb);
plot(handles.x,handles.sttable(1,:),'r');
hold on
plot(handles.x,handles.ndtable(1,:),'g'); 
plot(handles.x,handles.rdtable(1,:),'b'); 
hold off;
set(handles.newrgb,'HandleVisibility','OFF');

guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
end
function R2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.FinalImg=handles.im_original;
handles.sttable=handles.im_original(:,:,1);
handles.ndtable=handles.im_original(:,:,2);
handles.rdtable=handles.im_original(:,:,3);

set(handles.First,'HandleVisibility','ON');
axes(handles.First);
imshow(handles.sttable);
axis equal;
axis tight;
axis off;
set(handles.First,'HandleVisibility','OFF');


set(handles.Second,'HandleVisibility','ON');
axes(handles.Second);
imshow(handles.ndtable);
axis equal;
axis tight;
axis off;
set(handles.Second,'HandleVisibility','OFF');

set(handles.Third,'HandleVisibility','ON');
axes(handles.Third);
imshow(handles.rdtable);
axis equal;
axis tight;
axis off;
set(handles.Third,'HandleVisibility','OFF');

set(handles.ImgOriginal,'HandleVisibility','ON');
axes(handles.ImgOriginal);
image(handles.im_original);
axis equal;
axis tight;
axis off;
set(handles.ImgOriginal,'HandleVisibility','OFF');

set(handles.NewImg,'HandleVisibility','ON');
axes(handles.NewImg);
image(handles.FinalImg);
axis equal;
axis tight;
axis off;
set(handles.NewImg,'HandleVisibility','OFF');

set(handles.newrgb,'HandleVisibility','ON');
axes(handles.newrgb);
plot(handles.x,handles.sttable(1,:),'r');
hold on
plot(handles.x,handles.ndtable(1,:),'g'); 
plot(handles.x,handles.rdtable(1,:),'b'); 
hold off;
set(handles.newrgb,'HandleVisibility','OFF');


guidata(hObject, handles);


end



% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.slider,'HandleVisibility','ON');
handles.widthy=get(handles.slider,'value')

guidata(hObject, handles);
end
% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

