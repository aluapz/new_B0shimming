function varargout = GUI_WSSelect_ReconObject(varargin)

% Last Modified by GUIDE v2.5 12-Sep-2018 12:15:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_WSSelect_ReconObject_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_WSSelect_ReconObject_OutputFcn, ...
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

% --- Executes just before GUI_WSSelect_ReconObject is made visible.
function GUI_WSSelect_ReconObject_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for GUI_WSSelect_ReconObject
handles.output = hObject;

% Flag: show only recent recons for standalaone use or complete base workspace
%wsReconOnly=getappdata(0,'wsReconOnly');

% Allow only recent reconstructed images
%if(wsReconOnly)
    wsReconIdentifiers=evalin('base','who(''meas_*'')');
%else
%    wsReconIdentifiers=evalin('base','who');
%end

% List ws files 
set(handles.listbox_workspace,'String',wsReconIdentifiers);
set(handles.listbox_workspace,'Max',10);

% Update handles structure
guidata(hObject, handles);

function varargout = GUI_WSSelect_ReconObject_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function listbox_workspace_Callback(hObject, eventdata, handles)
function listbox_workspace_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function push_ok_Callback(hObject, eventdata, handles)

%- Import source data set
ws_list=get(handles.listbox_workspace,'String');
ws_selected=get(handles.listbox_workspace,'Value');

%- Make list of selected data sets
cnt=1;
for lVar=ws_selected
    wsSelection{cnt,1}=ws_list{lVar,1};
    cnt=cnt+1;
end

%- Save chosen variable in appdata
if(isempty(wsSelection))
    setappdata(0,'wsSelection',[]);
    close(GUI_WSSelect_ReconObject);
    return;
else
    setappdata(0,'wsSelection',wsSelection);
    close(GUI_WSSelect_ReconObject);    
end

function push_cancel_Callback(hObject, eventdata, handles)
setappdata(0,'wsSelection',[]);
close(GUI_WSSelect_ReconObject);
return;
