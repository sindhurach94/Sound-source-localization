function varargout = GUImain(varargin)
% GUIMAIN M-file for GUImain.fig
%      GUIMAIN, by itself, creates a new GUIMAIN or raises the existing
%      singleton*.
%
%      H = GUIMAIN returns the handle to a new GUIMAIN or the handle to
%      the existing singleton*.
%
%      GUIMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIMAIN.M with the given input arguments.
%
%      GUIMAIN('Property','Value',...) creates a new GUIMAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUImain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUImain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUImain

% Last Modified by GUIDE v2.5 25-Sep-2014 21:56:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUImain_OpeningFcn, ...
                   'gui_OutputFcn',  @GUImain_OutputFcn, ...
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


% --- Executes just before GUImain is made visible.
function GUImain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUImain (see VARARGIN)

% Choose default command line output for GUImain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUImain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUImain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
[f,p]=uigetfile('.tif');
I=imread(strcat(p,f));
axes(handles.axes1);
imshow(I);
title('Original');
image1=histeq(uint8(I));
W=str2double(get(handles.edit1,'string'));
%W=input('enter the threshold value (0 to 1)');
image1=FFT_enhance(image1,W);%fft
axes(handles.axes2);
imshow(image1);
title('FFT');
image1=adaptiveThres(double(image1),32);%binarization
axes(handles.axes3);
[o1Bound,o1Area]=direction(image1,16);
title('Directions');
[o2,o1Bound,o1Area]=draw_ROI(image1,o1Bound,o1Area);
o1=im2double(bwmorph(o2,'thin',Inf));
o1=im2double(bwmorph(o1,'clean'));
o1=im2double(bwmorph(o1,'hbreak'));
o1=im2double(bwmorph(o1,'spur'));
axes(handles.axes4);
imshow(o1);
title('Thinning');
[end_list1,branch_list1,ridgeMap1,edgeWidth]=find_minutia(o1,o1Bound,o1Area,16);
axes(handles.axes5);
show_minutia(o1,end_list1,branch_list1);
pause(0.5)
[pathMap1,real_end1,real_branch1]=elem_super_minutia(o1,end_list1,branch_list1,o1Area,ridgeMap1,edgeWidth);
axes(handles.axes5);
show_minutia(o1,real_end1,real_branch1);
W='a1.dat';
save(W,'real_end1','pathMap1','-ASCII');% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

[f,p]=uigetfile('.tif');
I=imread(strcat(p,f));
axes(handles.axes11);
imshow(I);
title('Original');
image1=histeq(uint8(I));
W=str2double(get(handles.edit1,'string'));
%W=input('enter the threshold value (0 to 1)');
image1=FFT_enhance(image1,W);%fft
axes(handles.axes12);
imshow(image1);
title('FFT');
image1=adaptiveThres(double(image1),32);%binarization
axes(handles.axes13);
[o1Bound,o1Area]=direction(image1,16);
title('Directions');
[o2,o1Bound,o1Area]=draw_ROI(image1,o1Bound,o1Area);
o1=im2double(bwmorph(o2,'thin',Inf));
o1=im2double(bwmorph(o1,'clean'));
o1=im2double(bwmorph(o1,'hbreak'));
o1=im2double(bwmorph(o1,'spur'));
axes(handles.axes14);
imshow(o1);
title('Thinning');
[end_list1,branch_list1,ridgeMap1,edgeWidth]=find_minutia(o1,o1Bound,o1Area,16);
axes(handles.axes15);
show_minutia(o1,end_list1,branch_list1);
pause(0.5)
[pathMap1,real_end1,real_branch1]=elem_super_minutia(o1,end_list1,branch_list1,o1Area,ridgeMap1,edgeWidth);
axes(handles.axes15);
show_minutia(o1,real_end1,real_branch1);

W='a2.dat';
save(W,'real_end1','pathMap1','-ASCII');

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
template1=load('a1.dat');
template2=load('a2.dat');
edgeWidth=10;
length1 = size(template1,1);
minu1 = template1(length1,3);
real_end1 = template1(1:minu1,:);
ridgeMap1= template1(minu1+1:length1,:);
length2 = size(template2,1);
minu2 = template2(length2,3);
real_end2 = template2(1:minu2,:);
ridgeMap2= template2(minu2+1:length2,:);
ridgeNum1 = minu1; 
minuNum1 = minu1;
ridgeNum2 = minu2;
minuNum2 = minu2;
max_percent=zeros(1,3);
for k1 = 1:minuNum1
      %minuNum2
      %calculate the similarities between ridgeMap1(k1) and ridgeMap(k2)
      %choose the current two minutia as origins and adjust other minutia
      %based on the origin minutia.
      newXY1 = min_org_TR(real_end1,k1,ridgeMap1);
   for k2 = 1:minuNum2
      newXY2 = min_org_TR(real_end2,k2,ridgeMap2);
      %choose the minimum ridge length
      compareL = min(size(newXY1,2),size(newXY2,2));
      %compare the similarity certainty of two ridge
      eachPairP = newXY1(1,1:compareL).*newXY2(1,1:compareL);
      pairPSquare = eachPairP.*eachPairP;
      temp = sum(pairPSquare);
      ridge_Sim_Coef = 0;
      if temp > 0
      ridge_Sim_Coef = sum(eachPairP)/( temp^.5 );
      end;
      
if ridge_Sim_Coef > 0.8
   		%transfer all the minutia in two fingerprint based on
   		%the reference pair of minutia
         fullXY1=min_org_TALL(real_end1,k1);
         fullXY2=min_org_TALL(real_end2,k2);
         minuN1 = size(fullXY1,2);
         minuN2 = size(fullXY2,2);
         xyrange=edgeWidth;
         num_match = 0;
         %if two minutia are within a box with width 20 and height 20,
         %they have small direction variation pi/3
         %then regard them as matched pair   
for i=1:minuN1 
   for j=1:minuN2  
      if (abs(fullXY1(1,i)-fullXY2(1,j))<xyrange & abs(fullXY1(2,i)-fullXY2(2,j))<xyrange)
         angle = abs(fullXY1(3,i) - fullXY2(3,j) );
         if or (angle < pi/3, abs(angle-pi)<pi/6)
         num_match=num_match+1;     
         break;
         end;
      end;   
   end;
end;
% get the largest matching score
current_match_percent=num_match;
if current_match_percent > max_percent(1,1);
   max_percent(1,1) = current_match_percent;
   max_percent(1,2) = k1;
   max_percent(1,3) = k2;
end;
num_match = 0;
end;
end;
end;
percent_match = max_percent(1,1)*100/minuNum1;
set(handles.edit2,'string',strcat(num2str(percent_match),' %'));
if percent_match<90
   warndlg('Un Authenticated');
else
    warndlg('Authenticated')
end
% percent_match=match_end(finger1,finger2,10);

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
