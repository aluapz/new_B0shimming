function varargout = Shim_tool(varargin)
% SHIM_TOOL MATLAB code for Shim_tool.fig
%      SHIM_TOOL, by itself, creates a new SHIM_TOOL or raises the existing
%      singleton*.
%
%      H = SHIM_TOOL returns the handle to a new SHIM_TOOL or the handle to
%      the existing singleton*.
%
%      SHIM_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHIM_TOOL.M with the given input arguments.
%
%      SHIM_TOOL('Property','Value',...) creates a new SHIM_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Shim_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Shim_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Shim_tool

% Last Modified by GUIDE v2.5 23-Aug-2019 14:06:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Shim_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @Shim_tool_OutputFcn, ...
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


% --- Executes just before Shim_tool is made visible.
function Shim_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Shim_tool (see VARARGIN)

% Choose default command line output for Shim_tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axes(handles.axes1);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

axes(handles.axes2);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

axes(handles.axes3);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

set(handles.slider_threshold, 'Min', 0, 'Value', 0.25 ,'Max', 1 ,  'SliderStep' , [1 /200 1 / 200]);
set(handles.text_threshold,'String','0.25'); 


% UIWAIT makes Shim_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Shim_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_load_dicom.
function pushbutton_load_dicom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_dicom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Voxel Position Parameters: 
set (handles.L , 'String', 0) ;
set (handles.A , 'String', 0) ;
set (handles.F , 'String', 0) ;
%Voxel Orientation Parameters: 
set (handles.T2C , 'String', 0) ;
set (handles.T2S , 'String', 0) ;
set (handles.Rot , 'String', 0) ;
%Voxel Dimensions: 
set (handles.R2L , 'String', 0) ;
set (handles.F2H , 'String', 0) ;
set (handles.A2P , 'String', 0) ;
%Output Shim Values
set (handles.a11 , 'String', '') ;
set (handles.b11 , 'String', '') ;
set (handles.a20 , 'String', '') ;
set (handles.a10 , 'String', '') ;
set (handles.a21 , 'String', '') ;
set (handles.b21 , 'String', '') ;
set (handles.a22 , 'String', '') ;
set (handles.b22 , 'String', '') ;
set (handles.a30 , 'String', '') ;
set (handles.a31 , 'String', '') ;
set (handles.b31 , 'String', '') ;
set (handles.a32 , 'String', '') ;
if get(handles.radiobutton_mask_fix,'Value') == 1
    mask = handles.data.mask;
    mask_contour = handles.data.mask_contour;
end
clear handles.data;
axes(handles.axes1);cla;
axes(handles.axes2);cla;
axes(handles.axes3);cla;
% Change segmentation type to single voxel, if 3D volume was chosen
if get(handles.uibuttongroup_segmentation,'selectedObject') == handles.radiobutton_volume
    set(handles.uibuttongroup_segmentation,'selectedObject', handles.radiobutton_singlevoxel); 
    set(handles.uipanel2,'Visible','On');
    set(handles.uipanel3,'Visible','On');
    set(handles.uipanel4,'Visible','On');
    set(handles.uipanel5,'Visible','Off');
    set(handles.uipanel6,'Visible','Off');
%     set(handles.text_draw, 'Visible','Off'); 
end

pathName = uigetdir( [], 'Please select the folder containing the DICOM files' );
if ( pathName ~= 0 )
    listing = dir( pathName );
    h = waitbar( 0, 'Loading files...' );
    for f = 1 : length( listing )
        waitbar (f / length( listing ) )
        fileName = listing( f ).name;
        [~, ~, ext] = fileparts( fileName );
        if( strcmp( ext , '.IMA' ) )
            obj = read_dicom_header_local( strcat( pathName, '\', fileName ) );
            if ( strcmp( obj.acqname( end-4 ), 'P' ) )
                slicenum = obj.ima;
                B0map( :, :, slicenum ) = obj.pix;
                szz( slicenum ) =  obj.pos(3);
                deltaTE= abs( obj.TE - obj.specTE / 1000 ) ; %in msec
                xx = obj.norm(1); %image orientation
                xy = obj.norm(2);
                xz = obj.norm(3);
                yx = obj.norm(4);
                yy = obj.norm(5);
                yz = obj.norm(6);
                sx = obj.pos(1); %image position
                sy = obj.pos(2);
                deltai = obj.PhaseFoV / size( B0map, 1 ); %in mm
                deltaj = obj.ReadoutFoV / size( B0map, 1 ); %in mm
            elseif ( strcmp( obj.acqname( end-4 ), 'M' ) )
                slicenum = obj.ima;
                Magn( :, :, slicenum ) = imgaussfilt(obj.pix,2);
            end
        end
    end
    close( h );
    if ( ~exist( 'B0map', 'var' ) || size( B0map, 3 ) ~= obj.nslice || size( B0map, 3 ) == 0 )
        errordlg('Phase maps are not copied properly from the scanner or wrong folder was selected! try again');
        return;
    elseif ( ~exist( 'Magn', 'var' ) || size(Magn,3) ~= obj.nslice || size( Magn,3 ) == 0 )
        errordlg('Magn images are not copied properly from the scanner or wrong folder was selected!try again');
        return;
    end
    
    %Convert Phase Difference to B0 Map
    B0map = B0map/4096/( deltaTE*1e-3)/(42.577e6);
    
    handles.data = struct ( 'B0map' , B0map, 'szz' , szz , 'Magn', Magn,...
        'deltaTE', deltaTE, 'deltai' , deltai, 'deltaj', deltaj , 'sy', ...
        sy, 'sx', sx , 'yz',  yz, 'yy',  yy, 'yx',  yx, 'xz',  xz, 'xy',...
        xy , 'xx',  xx );
    
   %Set Mask Data -> Empty
    if get(handles.radiobutton_mask_fix,'Value') == 0
        handles.data.mask = [];
        handles.data.mask_contour = [];
    else
        handles.data.mask = mask; 
        handles.data.mask_contour = mask_contour;
    end
    guidata( hObject, handles );
    
    %Set Slice Slider Values
    set(handles.Slice, 'Min', 1, 'Value', size(Magn,3)/2  ,'Max', obj.nslice ,  'SliderStep' , [1 / obj.nslice 1 / obj.nslice]);
    set(handles.SliceCor, 'Min', 1, 'Value', size(Magn,2)/2 ,'Max', size(Magn,2) ,  'SliderStep' , [1 / size(Magn,2) 1 / size(Magn,2)]);
    set(handles.SliceSag, 'Min', 1, 'Value', size(Magn,1)/2 ,'Max', size(Magn,1) ,  'SliderStep' , [1 / size(Magn,1) 1 / size(Magn,1)]);
    set(handles.edit_Slices, 'String', num2str(int32(size(Magn,3)))); 
    set(handles.edit_CurrentSlice, 'String', num2str(int32(size(Magn,3)/2))); 
    
    %Show images
    showimages(handles); 
end


% --- Executes on button press in pushbutton_loadmat.
function pushbutton_loadmat_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadmat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton_shim.

%Loads Sodium ReconObject from Matlab Workspace and calculates B0 map

%First set UI handles:
%Voxel Position Parameters: 
set (handles.L , 'String', 0) ;
set (handles.A , 'String', 0) ;
set (handles.F , 'String', 0) ;
%Voxel Orientation Parameters: 
set (handles.T2C , 'String', 0) ;
set (handles.T2S , 'String', 0) ;
set (handles.Rot , 'String', 0) ;
%Voxel Dimensions: 
set (handles.R2L , 'String', 0) ;
set (handles.F2H , 'String', 0) ;
set (handles.A2P , 'String', 0) ;
%Output Shim Values
set (handles.a11 , 'String', '') ;
set (handles.b11 , 'String', '') ;
set (handles.a20 , 'String', '') ;
set (handles.a10 , 'String', '') ;
set (handles.a21 , 'String', '') ;
set (handles.b21 , 'String', '') ;
set (handles.a22 , 'String', '') ;
set (handles.b22 , 'String', '') ;
set (handles.a30 , 'String', '') ;
set (handles.a31 , 'String', '') ;
set (handles.b31 , 'String', '') ;
set (handles.a32 , 'String', '') ;

clear handles.data;
axes(handles.axes1);cla;
axes(handles.axes2);cla;
axes(handles.axes3);cla;

%Load ReconObject from .mat-file: 
[fileName,pathName] = uigetfile( '', 'Please select the ReconObject' );
if pathName == 0
    return;
end
load(fullfile(pathName,fileName));
ReconObject = currReconObj;

[handles, Magn] = Shim_tool_calcB0map(ReconObject, handles);
guidata( hObject, handles );

%Set Slice Slider Values
set(handles.Slice, 'Min', 1, 'Value', size(Magn,3)/2  ,'Max', size(Magn,3),  'SliderStep' , [1 / size(Magn,3) 1 / size(Magn,3)]);
set(handles.SliceCor, 'Min', 1, 'Value', size(Magn,2)/2 ,'Max', size(Magn,2) ,  'SliderStep' , [1 / size(Magn,2) 1 / size(Magn,2)]);
set(handles.SliceSag, 'Min', 1, 'Value', size(Magn,1)/2 ,'Max', size(Magn,1) ,  'SliderStep' , [1 / size(Magn,1) 1 / size(Magn,1)]);
set(handles.edit_Slices, 'String', num2str(int32(size(Magn,3)))); 
set(handles.edit_CurrentSlice, 'String', num2str(int32(size(Magn,3)/2))); 

%Show images
showimages(handles); 

%Set handles for mask calculation:
guidata(hObject, handles);
% set(handles.slider_threshold, 'Min', 0, 'Value', 0.5 ,'Max', 1 ,  'SliderStep' , [1 /200 1 / 200]);
set(handles.slicerange_start,'String',round(num2str(1)*0.13)); 
set(handles.slicerange_stop,'String',round(num2str(size(handles.data.B0map,3))*0.87)); 
calcMask_autosegment_fill(handles,hObject); 


% --- Executes on button press in pushbutton_loadraw.
function pushbutton_loadraw_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear handles.data;
axes(handles.axes1);cla;
axes(handles.axes2);cla;
axes(handles.axes3);cla;

%Load ReconObject from .mat-file: 
[fileName,pathName] = uigetfile( '*.dat', 'Please select the Rawdata File' );
if pathName == 0
    return;
end

params.path = pathName;
params.filename = fileName;
params = RadialRecon_DataInfo_mapVBVD(params) ;

params = Shim_tool_getReconParams(params,handles);

ReconObject = Shim_tool_reconstruct(params); 

[handles, Magn] = Shim_tool_calcB0map(ReconObject, handles);
guidata( hObject, handles );

%Set Slice Slider Values
set(handles.Slice, 'Min', 1, 'Value', size(Magn,3)/2  ,'Max', size(Magn,3),  'SliderStep' , [1 / size(Magn,3) 1 / size(Magn,3)]);
set(handles.SliceCor, 'Min', 1, 'Value', size(Magn,2)/2 ,'Max', size(Magn,2) ,  'SliderStep' , [1 / size(Magn,2) 1 / size(Magn,2)]);
set(handles.SliceSag, 'Min', 1, 'Value', size(Magn,1)/2 ,'Max', size(Magn,1) ,  'SliderStep' , [1 / size(Magn,1) 1 / size(Magn,1)]);
set(handles.edit_Slices, 'String', num2str(int32(size(Magn,3)))); 
set(handles.edit_CurrentSlice, 'String', num2str(int32(size(Magn,3)/2))); 

%Show images
showimages(handles); 

%Set handles for mask calculation:
guidata(hObject, handles);
set(handles.slicerange_start,'String',num2str(round(size(handles.data.B0map,3)*0.13))); 
set(handles.slicerange_stop,'String',num2str(round(size(handles.data.B0map,3)*0.87))); 
% set(handles.slicerange_start,'String',num2str(1)); 
% set(handles.slicerange_stop,'String',num2str(size(handles.data.B0map,3))); 
calcMask_autosegment_fill(handles,hObject); 


function pushbutton_shim_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_shim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~isfield (handles , 'data'))
    return;
end
if (~isfield (handles.data , 'mask')) 
    errordlg('Please select mask first!');
    return;
end

handles.order = get(handles.select_shimorder,'Value'); 
%Prepare A and B matrices
[A,B] = genMat(handles); 

handles.data.A = A;
handles.data.B = B; 

%Calculate shim values: 
Vals = calcShim(handles.data.A,handles.data.B,handles);       %Calculate Shim values

%Assign Results to Workspace:
assignin('base','mask',handles.data.mask); 
assignin('base','Shimvalues',Vals);

%Display results in UI: 
if handles.order == 1
    set( handles.a11, 'String', num2str(Vals(1),'%15.2f' ) )
    set( handles.b11, 'String', num2str(Vals(2),'%15.2f' ) )
    set( handles.a10, 'String', num2str(Vals(3),'%15.2f' ) )
elseif handles.order == 2
    set( handles.a11, 'String', num2str(Vals(1),'%15.2f' ) )
    set( handles.b11, 'String', num2str(Vals(2),'%15.2f' ) )
    set( handles.a10, 'String', num2str(Vals(3),'%15.2f' ) )
    set( handles.a20, 'String', num2str(Vals(4),'%15.2f' ) )
    set( handles.a21, 'String', num2str(Vals(5),'%15.2f' ) )
    set( handles.b21, 'String', num2str(Vals(6),'%15.2f' ) )
    set( handles.a22, 'String', num2str(Vals(7),'%15.2f' ) )
    set( handles.b22, 'String', num2str(Vals(8),'%15.2f' ) )
elseif handles.order == 3
    set( handles.a11, 'String', num2str(Vals(1),'%15.2f' ) )
    set( handles.b11, 'String', num2str(Vals(2),'%15.2f' ) )
    set( handles.a10, 'String', num2str(Vals(3),'%15.2f' ) )
    set( handles.a20, 'String', num2str(Vals(4),'%15.2f' ) )
    set( handles.a21, 'String', num2str(Vals(5),'%15.2f' ) )
    set( handles.b21, 'String', num2str(Vals(6),'%15.2f' ) )
    set( handles.a22, 'String', num2str(Vals(7),'%15.2f' ) )
    set( handles.b22, 'String', num2str(Vals(8),'%15.2f' ) )
    set( handles.a30, 'String', num2str(Vals(9),'%15.2f' ) )
    set( handles.a31, 'String', num2str(Vals(10),'%15.2f' ) )
    set( handles.b31, 'String', num2str(Vals(11),'%15.2f' ) )
    set( handles.a32, 'String', num2str(Vals(12),'%15.2f' ) )
end
    

% --- Executes on slider movement.
function Slice_Callback(hObject, eventdata, handles)
% hObject    handle to Slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if (~isfield (handles , 'data'))
    return;
end
showimages(handles); 
set(handles.edit_CurrentSlice, 'String', num2str(int32(get(handles.Slice,'Value')))); 

% --- Executes during object creation, after setting all properties.
function Slice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function SliceSag_Callback(hObject, eventdata, handles)
% hObject    handle to SliceSag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if (~isfield (handles , 'data'))
    return;
end
showimages(handles); 


% --- Executes during object creation, after setting all properties.
function SliceSag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliceSag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function SliceCor_Callback(hObject, eventdata, handles)
% hObject    handle to SliceCor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if (~isfield (handles , 'data'))
    return;
end
showimages(handles); 


% --- Executes during object creation, after setting all properties.
function SliceCor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliceCor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function Rot_Callback(hObject, eventdata, handles)
% hObject    handle to Rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rot as text
%        str2double(get(hObject,'String')) returns contents of Rot as a double
if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
elseif (isnan ( str2double (get(hObject,'String')) ) || strcmp(get(hObject,'String'),'i') ||  strcmp(get(hObject,'String'),'-i') ||  strcmp(get(hObject,'String'),'j') ||  strcmp(get(hObject,'String'),'-j')  )
    errordlg('Please only enter numbers');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end

% --- Executes during object creation, after setting all properties.
function Rot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T2S_Callback(hObject, eventdata, handles)
% hObject    handle to T2S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T2S as text
%        str2double(get(hObject,'String')) returns contents of T2S as a double
if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
elseif (isnan ( str2double (get(hObject,'String')) ) || strcmp(get(hObject,'String'),'i') ||  strcmp(get(hObject,'String'),'-i') ||  strcmp(get(hObject,'String'),'j') ||  strcmp(get(hObject,'String'),'-j')  )
    errordlg('Please only enter numbers');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end


% --- Executes during object creation, after setting all properties.
function T2S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T2S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T2C_Callback(hObject, eventdata, handles)
% hObject    handle to T2C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T2C as text
%        str2double(get(hObject,'String')) returns contents of T2C as a double

if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
elseif (isnan ( str2double (get(hObject,'String')) ) || strcmp(get(hObject,'String'),'i') ||  strcmp(get(hObject,'String'),'-i') ||  strcmp(get(hObject,'String'),'j') ||  strcmp(get(hObject,'String'),'-j')  )
    errordlg('Please only enter numbers');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end
% --- Executes during object creation, after setting all properties.
function T2C_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T2C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function F_Callback(hObject, eventdata, handles)
% hObject    handle to F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F as text
%        str2double(get(hObject,'String')) returns contents of F as a double

if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
elseif (isnan ( str2double (get(hObject,'String')) ) || strcmp(get(hObject,'String'),'i') ||  strcmp(get(hObject,'String'),'-i') ||  strcmp(get(hObject,'String'),'j') ||  strcmp(get(hObject,'String'),'-j')  )
    errordlg('Please only enter numbers');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end

% --- Executes during object creation, after setting all properties.
function F_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A_Callback(hObject, eventdata, handles)
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A as text
%        str2double(get(hObject,'String')) returns contents of A as a double

if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
elseif (isnan ( str2double (get(hObject,'String')) ) || strcmp(get(hObject,'String'),'i') ||  strcmp(get(hObject,'String'),'-i') ||  strcmp(get(hObject,'String'),'j') ||  strcmp(get(hObject,'String'),'-j')  )
    errordlg('Please only enter numbers');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end

% --- Executes during object creation, after setting all properties.
function A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L_Callback(hObject, eventdata, handles)
% hObject    handle to L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L as text
%        str2double(get(hObject,'String')) returns contents of L as a double

if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
elseif (isnan ( str2double (get(hObject,'String')) ) || strcmp(get(hObject,'String'),'i') ||  strcmp(get(hObject,'String'),'-i') ||  strcmp(get(hObject,'String'),'j') ||  strcmp(get(hObject,'String'),'-j')  )
    errordlg('Please only enter numbers');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end

% --- Executes during object creation, after setting all properties.
function L_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R2L_Callback(hObject, eventdata, handles)
% hObject    handle to R2L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R2L as text
%        str2double(get(hObject,'String')) returns contents of R2L as a double

if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
elseif (isnan ( str2double (get(hObject,'String')) ) || strcmp(get(hObject,'String'),'i') ||  strcmp(get(hObject,'String'),'-i') ||  strcmp(get(hObject,'String'),'j') ||  strcmp(get(hObject,'String'),'-j')  )
    errordlg('Please only enter numbers');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end

% --- Executes during object creation, after setting all properties.
function R2L_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A2P_Callback(hObject, eventdata, handles)
% hObject    handle to A2P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A2P as text
%        str2double(get(hObject,'String')) returns contents of A2P as a double

if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
elseif (isnan ( str2double (get(hObject,'String')) ) || strcmp(get(hObject,'String'),'i') ||  strcmp(get(hObject,'String'),'-i') ||  strcmp(get(hObject,'String'),'j') ||  strcmp(get(hObject,'String'),'-j')  )
    errordlg('Please only enter numbers');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end

% --- Executes during object creation, after setting all properties.
function A2P_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function F2H_Callback(hObject, eventdata, handles)
% hObject    handle to F2H (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F2H as text
%        str2double(get(hObject,'String')) returns contents of F2H as a double
if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
elseif (isnan ( str2double (get(hObject,'String')) ) || strcmp(get(hObject,'String'),'i') ||  strcmp(get(hObject,'String'),'-i') ||  strcmp(get(hObject,'String'),'j') ||  strcmp(get(hObject,'String'),'-j')  )
    errordlg('Please only enter numbers');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end

% --- Executes during object creation, after setting all properties.
function F2H_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F2H (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in select_shimorder.
function select_shimorder_Callback(hObject, eventdata, handles)
% hObject    handle to select_shimorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_shimorder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_shimorder

handles.order = get(handles.select_shimorder,'Value'); 
if handles.order == 1
    %Clear first order values
    set (handles.a11 , 'String', '') ;
    set (handles.a10 , 'String', '') ;
    set (handles.b11 , 'String', '') ;

    %Set Order 2 values visibility off
    set(handles.a20,'Visible', 'Off'); 
    set(handles.a21,'Visible', 'Off'); 
    set(handles.b21,'Visible', 'Off'); 
    set(handles.a22,'Visible', 'Off'); 
    set(handles.b22,'Visible', 'Off'); 
    
    set(handles.text_a20,'Visible', 'Off'); 
    set(handles.text_a21,'Visible', 'Off'); 
    set(handles.text_b21,'Visible', 'Off'); 
    set(handles.text_a22,'Visible', 'Off'); 
    set(handles.text_b22,'Visible', 'Off'); 
    
    %Set order 3 values visibility off
    set(handles.a30,'Visible', 'Off'); 
    set(handles.a31,'Visible', 'Off'); 
    set(handles.b31,'Visible', 'Off'); 
    set(handles.a32,'Visible', 'Off'); 
    
    set(handles.text_a30,'Visible', 'Off'); 
    set(handles.text_a31,'Visible', 'Off'); 
    set(handles.text_b31,'Visible', 'Off'); 
    set(handles.text_a32,'Visible', 'Off'); 
    
elseif handles.order == 2
    %Clear first order values
    set (handles.a11 , 'String', '') ;
    set (handles.a10 , 'String', '') ;
    set (handles.b11 , 'String', '') ;
    
    % Set order 2 values visibility on
    set(handles.a20,'Visible', 'On'); 
    set(handles.a21,'Visible', 'On'); 
    set(handles.b21,'Visible', 'On'); 
    set(handles.a22,'Visible', 'On'); 
    set(handles.b22,'Visible', 'On'); 
    
    set(handles.text_a20,'Visible', 'On'); 
    set(handles.text_a21,'Visible', 'On'); 
    set(handles.text_b21,'Visible', 'On'); 
    set(handles.text_a22,'Visible', 'On'); 
    set(handles.text_b22,'Visible', 'On'); 
    
    set (handles.a20 , 'String', '') ;
    set (handles.a21 , 'String', '') ;
    set (handles.b21 , 'String', '') ;
    set (handles.a22 , 'String', '') ;
    set (handles.b22 , 'String', '') ;
    
    %Set order 3 values visibility off
    set(handles.a30,'Visible', 'Off'); 
    set(handles.a31,'Visible', 'Off'); 
    set(handles.b31,'Visible', 'Off'); 
    set(handles.a32,'Visible', 'Off'); 
    
    set (handles.a30 , 'String', '') ;
    set (handles.a31 , 'String', '') ;
    set (handles.b31 , 'String', '') ;
    set (handles.a32 , 'String', '') ;
    
    set(handles.text_a30,'Visible', 'Off'); 
    set(handles.text_a31,'Visible', 'Off'); 
    set(handles.text_b31,'Visible', 'Off'); 
    set(handles.text_a32,'Visible', 'Off'); 
    
elseif handles.order == 3 
    %Clear first order values
    set (handles.a11 , 'String', '') ;
    set (handles.a10 , 'String', '') ;
    set (handles.b11 , 'String', '') ;
    
    % Set order 2 values visibility on
    set(handles.a20,'Visible', 'On'); 
    set(handles.a21,'Visible', 'On'); 
    set(handles.b21,'Visible', 'On'); 
    set(handles.a22,'Visible', 'On'); 
    set(handles.b22,'Visible', 'On'); 
    
    set (handles.a20 , 'String', '') ;
    set (handles.a21 , 'String', '') ;
    set (handles.b21 , 'String', '') ;
    set (handles.a22 , 'String', '') ;
    set (handles.b22 , 'String', '') ;
    
    set(handles.text_a20,'Visible', 'On'); 
    set(handles.text_a21,'Visible', 'On'); 
    set(handles.text_b21,'Visible', 'On'); 
    set(handles.text_a22,'Visible', 'On'); 
    set(handles.text_b22,'Visible', 'On'); 
    
    %Set order 3 values visibility on
    set(handles.a30,'Visible', 'On'); 
    set(handles.a31,'Visible', 'On'); 
    set(handles.b31,'Visible', 'On'); 
    set(handles.a32,'Visible', 'On'); 
    
    set (handles.a30 , 'String', '') ;
    set (handles.a31 , 'String', '') ;
    set (handles.b31 , 'String', '') ;
    set (handles.a32 , 'String', '') ;
  
    set(handles.text_a30,'Visible', 'On'); 
    set(handles.text_a31,'Visible', 'On'); 
    set(handles.text_b31,'Visible', 'On'); 
    set(handles.text_a32,'Visible', 'On'); 
end 

if ( ~isfield (handles , 'data') )
    errordlg('Load data first');
    set ( hObject, 'String' , '0');
    return;
else
    SuccessFlag = calcMask_singlevoxel(handles, hObject);
    if (~SuccessFlag)
        set ( hObject, 'String' , '0');
    end
end

% --- Executes during object creation, after setting all properties.
function select_shimorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_shimorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup_segmentation.
function uibuttongroup_segmentation_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_segmentation 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newButton=get(eventdata.NewValue,'tag');

switch newButton
    case 'radiobutton_singlevoxel'
        set(handles.uipanel2,'Visible','On');
        set(handles.uipanel3,'Visible','On');
        set(handles.uipanel4,'Visible','On');
        set(handles.uipanel5,'Visible','Off');
        set(handles.uipanel6,'Visible','Off');
        set(handles.radiobutton_fill, 'Visible', 'Off'); 
        if ( isfield (handles,'data') )
            if ( ~isempty (handles.data.mask) )
                handles.data.mask = []; 
            end
            if ( ~isempty (handles.data.mask_contour) )
                handles.data.mask_contour =[]; 
            end
        end
        guidata(hObject, handles);
        showimages(handles); %Plot images
    case 'radiobutton_autosegment'
        set(handles.uipanel2,'Visible','Of');
        set(handles.uipanel3,'Visible','Of');
        set(handles.uipanel4,'Visible','Of');
        set(handles.uipanel5,'Visible','On');
        set(handles.uipanel6,'Visible','On');
        set(handles.radiobutton_fill, 'Visible', 'On'); 
        if ~isfield(handles,'data')
            errordlg('Please load B0 map first!');
            return; 
        else
            if ( ~isempty (handles.data.mask) )
                handles.data.mask = []; 
            end
            if ( ~isempty (handles.data.mask_contour) )
                handles.data.mask_contour =[]; 
            end
            showimages(handles); %Plot images
        end
        guidata(hObject, handles);
        set(handles.slider_threshold, 'Min', 0, 'Value', 0.5 ,'Max', 1 ,  'SliderStep' , [1 /200 1 / 200]);
        set(handles.text_threshold, 'String', '0.25');
        set(handles.slicerange_start,'String',num2str(1)); 
        set(handles.slicerange_stop,'String',num2str(size(handles.data.B0map,3))); 
        calcMask_autosegment_fill(handles,hObject); 
end


% --- Executes on slider movement.
function slider_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to slider_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

thres = get(handles.slider_threshold, 'Value'); 
set(handles.text_threshold,'String',num2str(thres));
calcMask_autosegment_fill(handles , hObject);

% --- Executes during object creation, after setting all properties.
function slider_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slicerange_start_Callback(hObject, eventdata, handles)
% hObject    handle to slicerange_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slicerange_start as text
%        str2double(get(hObject,'String')) returns contents of slicerange_start as a double
calcMask_autosegment_fill(handles , hObject);

% --- Executes during object creation, after setting all properties.
function slicerange_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slicerange_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slicerange_stop_Callback(hObject, eventdata, handles)
% hObject    handle to slicerange_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slicerange_stop as text
%        str2double(get(hObject,'String')) returns contents of slicerange_stop as a double

calcMask_autosegment_fill(handles , hObject);

% --- Executes during object creation, after setting all properties.
function slicerange_stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slicerange_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigma as text
%        str2double(get(hObject,'String')) returns contents of edit_sigma as a double


% --- Executes during object creation, after setting all properties.
function edit_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_fill.
function radiobutton_fill_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_fill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_fill
calcMask_autosegment_fill(handles , hObject);

function a11_Callback(hObject, eventdata, handles)
% hObject    handle to a11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a11 as text
%        str2double(get(hObject,'String')) returns contents of a11 as a double


% --- Executes during object creation, after setting all properties.
function a11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function b11_Callback(hObject, eventdata, handles)
% hObject    handle to b11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b11 as text
%        str2double(get(hObject,'String')) returns contents of b11 as a double


% --- Executes during object creation, after setting all properties.
function b11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a20_Callback(hObject, eventdata, handles)
% hObject    handle to a20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a20 as text
%        str2double(get(hObject,'String')) returns contents of a20 as a double


% --- Executes during object creation, after setting all properties.
function a20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a10_Callback(hObject, eventdata, handles)
% hObject    handle to a10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a10 as text
%        str2double(get(hObject,'String')) returns contents of a10 as a double


% --- Executes during object creation, after setting all properties.
function a10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a21_Callback(hObject, eventdata, handles)
% hObject    handle to a21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a21 as text
%        str2double(get(hObject,'String')) returns contents of a21 as a double


% --- Executes during object creation, after setting all properties.
function a21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b21_Callback(hObject, eventdata, handles)
% hObject    handle to b21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b21 as text
%        str2double(get(hObject,'String')) returns contents of b21 as a double


% --- Executes during object creation, after setting all properties.
function b21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a22_Callback(hObject, eventdata, handles)
% hObject    handle to a22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a22 as text
%        str2double(get(hObject,'String')) returns contents of a22 as a double


% --- Executes during object creation, after setting all properties.
function a22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b22_Callback(hObject, eventdata, handles)
% hObject    handle to b22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b22 as text
%        str2double(get(hObject,'String')) returns contents of b22 as a double


% --- Executes during object creation, after setting all properties.
function b22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a30_Callback(hObject, eventdata, handles)
% hObject    handle to a30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a30 as text
%        str2double(get(hObject,'String')) returns contents of a30 as a double


% --- Executes during object creation, after setting all properties.
function a30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a31_Callback(hObject, eventdata, handles)
% hObject    handle to a31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a31 as text
%        str2double(get(hObject,'String')) returns contents of a31 as a double


% --- Executes during object creation, after setting all properties.
function a31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b31_Callback(hObject, eventdata, handles)
% hObject    handle to b31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b31 as text
%        str2double(get(hObject,'String')) returns contents of b31 as a double


% --- Executes during object creation, after setting all properties.
function b31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a32_Callback(hObject, eventdata, handles)
% hObject    handle to a32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a32 as text
%        str2double(get(hObject,'String')) returns contents of a32 as a double


% --- Executes during object creation, after setting all properties.
function a32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

