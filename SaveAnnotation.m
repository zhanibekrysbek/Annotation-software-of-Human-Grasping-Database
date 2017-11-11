function varargout = SaveAnnotation(varargin)
% SAVEANNOTATION MATLAB code for SaveAnnotation.fig
%      SAVEANNOTATION part of a ANNOTATION SOFTWARE. Main purpose of this
%      is to finalize annotation for a grasp instance and preview for its
%      correctness.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SaveAnnotation

% Last Modified by GUIDE v2.5 13-Jun-2017 11:04:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SaveAnnotation_OpeningFcn, ...
    'gui_OutputFcn',  @SaveAnnotation_OutputFcn, ...
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


% --- Executes just before SaveAnnotation is made visible.
function SaveAnnotation_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SaveAnnotation (see VARARGIN)

% Choose default command line output for SaveAnnotation
handles.output = hObject;
% flag for a variable to indicate status of saving annotation instance
handles.completed = 0;
if nargin >= 4
    handles.NewGrasp = varargin{1};
    handles.storageFileName = varargin{2};
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SaveAnnotation wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line. In order
% to acknowledge parent window for completeness of the annotation. 
%   passing argument completed = 1 indicates that grasp instance was save
%   successfully; 
%   passing argument completed = 0 indicates that grasp instance was
%   rejected (cancel). Based on this variable parent window modifies its
%   parameters
function varargout = SaveAnnotation_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.completed;
delete(handles.figure1);




% --- Executes on button press in endOk. Final stage for including a grasp
% instance. User should press this button when he is ready to include
% current grasping instance to a dataset
function endOk_Callback(hObject, eventdata, handles)
% hObject    handle to endOk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.completed = 1;

fid = fopen(handles.storageFileName,'a+');
n = size(handles.toString,1);
% use repmat to construct repeating formats
% ( numColumns-1 because no comma on last one)
headerFmt = repmat('%s,',1,n-1);
fprintf(fid,[headerFmt,'%s\n'],handles.toString{1:end});
fclose(fid);

guidata(hObject, handles);
pause(0.1);
close;


% --- Executes on button press in preview. Preview button is designed to
% let the user see all input parameters for the annotation of grasp
% instance. It will display the same line that will be included to a
% dataset.
function preview_Callback(hObject, ~, handles)

handles.NewGrasp = orderfields(handles.NewGrasp, {'ID', 'Subject', 'Grasp',...
    'ADL', 'Video', 'StartFrame', 'EndFrame', 'OppType', 'PIP', ...
    'VirtualFingers', 'Thumb', 'Duration', 'SequenceNum'});

set(handles.graspIDcheck, 'String', handles.NewGrasp.ID);
set(handles.adlCheck, 'String', handles.NewGrasp.ADL);
set(handles.graspCheck, 'String', handles.NewGrasp.Grasp);
set(handles.startFrameCheck, 'String', handles.NewGrasp.StartFrame);
set(handles.endFrameCheck, 'String', handles.NewGrasp.EndFrame);
set(handles.videoCheck, 'String', handles.NewGrasp.Video);
set(handles.subjectCheck, 'String', handles.NewGrasp.Subject);
set(handles.durationCheck, 'String', handles.NewGrasp.Duration);

handles.toString = struct2cell(handles.NewGrasp);

n = size(handles.toString,1);
% use repmat to construct repeating formats
% ( numColumns-1 because no comma on last one)
headerFmt = repmat(' %s,',1,n-1);

set(handles.annotationView, 'String', sprintf([headerFmt,' %s\n'],handles.toString{1:end}));

guidata(hObject, handles);


% --- Executes on button press in cancel. In case user may want to cancel
% current grasp instance if he/she is not confident. 
function cancel_Callback(hObject, ~, handles)
% set completed variable to 0, and close the window.
handles.completed = 0;
guidata(hObject, handles);
close;


% --- Executes on button press in graspType. Calls another window to select
% which grasp types matches to current frame range.
function graspType_Callback(hObject, ~, handles)
% call another window to select one grasp type and receive its name
[handles.graspS, img] = GraspTypes();
set(handles.graspType, 'String', handles.graspS);
% Show the image of the grasp to confirm visually
handles.NewGrasp.Grasp = handles.graspS;
axes(handles.axes1);
imshow(img);
% according to GRASP comprehensive taxonomy we assign properties to each
% grasp and record to dataset.
switch handles.graspS
    case 'large diameter'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Abd';
    case 'small diameter'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Abd';
    case 'medium wrap'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Abd';
    case 'adducted thumb'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Add';
    case 'light tool'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Add';
    case 'prismatic 4 finger'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Abd';
    case 'prismatic 3 finger'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2-4';
        handles.NewGrasp.Thumb = 'Abd';
    case 'prismatic 2 finger'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2-3';
        handles.NewGrasp.Thumb = 'Abd';
    case 'palmar pinch'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2';
        handles.NewGrasp.Thumb = 'Abd';
    case 'power disk'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Abd';
    case 'power sphere'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Abd';
    case 'precision disk'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Abd';
    case 'precision sphere'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Abd';
    case 'tripod'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2-3';
        handles.NewGrasp.Thumb = 'Abd';
    case 'fixed hook'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Add';
    case 'lateral'
        handles.NewGrasp.OppType = 'Side';
        handles.NewGrasp.PIP = 'Intermediate';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Add';
    case 'index finger extension'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '3-5';
        handles.NewGrasp.Thumb = 'Add';
    case 'extension type'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-4';
        handles.NewGrasp.Thumb = 'Abd';
    case 'distal type'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Abd';
    case 'writing tripod'
        handles.NewGrasp.OppType = 'Side';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '3';
        handles.NewGrasp.Thumb = 'Abd';
    case 'tripod variation'
        handles.NewGrasp.OppType = 'Side';
        handles.NewGrasp.PIP = 'Intermediate';
        handles.NewGrasp.VirtualFingers = '3-4';
        handles.NewGrasp.Thumb = 'Abd';
    case 'parallel extension'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Add';
    case 'adduction grip'
        handles.NewGrasp.OppType = 'Side';
        handles.NewGrasp.PIP = 'Intermediate';
        handles.NewGrasp.VirtualFingers = '3';
        handles.NewGrasp.Thumb = 'Abd';
    case 'tip pinch'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2';
        handles.NewGrasp.Thumb = 'Abd';
    case 'lateral tripod'
        handles.NewGrasp.OppType = 'Side';
        handles.NewGrasp.PIP = 'Intermediate';
        handles.NewGrasp.VirtualFingers = '3';
        handles.NewGrasp.Thumb = 'Add';
    case 'sphere 4 finger'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2';
        handles.NewGrasp.Thumb = 'Abd';
    case 'quadpod'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2-4';
        handles.NewGrasp.Thumb = 'Abd';
    case 'sphere 3 finger'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-3';
        handles.NewGrasp.Thumb = 'Abd';
    case 'stick'
        handles.NewGrasp.OppType = 'Side';
        handles.NewGrasp.PIP = 'Intermediate';
        handles.NewGrasp.VirtualFingers = '2';
        handles.NewGrasp.Thumb = 'Add';
    case 'palmar'
        handles.NewGrasp.OppType = 'Palm';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2-5';
        handles.NewGrasp.Thumb = 'Add';
    case 'ring'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Power';
        handles.NewGrasp.VirtualFingers = '2';
        handles.NewGrasp.Thumb = 'Abd';
    case 'ventral'
        handles.NewGrasp.OppType = 'Side';
        handles.NewGrasp.PIP = 'Intermediate';
        handles.NewGrasp.VirtualFingers = '2';
        handles.NewGrasp.Thumb = 'Add';
    case 'inferior pincer'
        handles.NewGrasp.OppType = 'Pad';
        handles.NewGrasp.PIP = 'Precision';
        handles.NewGrasp.VirtualFingers = '2';
        handles.NewGrasp.Thumb = 'Abd';
    case 'push'
        handles.NewGrasp.OppType = 'null';
        handles.NewGrasp.PIP = 'null';
        handles.NewGrasp.VirtualFingers = 'null';
        handles.NewGrasp.Thumb = 'null';
    case 'lift'
        handles.NewGrasp.OppType = 'null';
        handles.NewGrasp.PIP = 'null';
        handles.NewGrasp.VirtualFingers = 'null';
        handles.NewGrasp.Thumb = 'null';
end

guidata(hObject, handles)


% --- Executes when selected object is changed in adl. Radio button group
% for selecting type of ADL
function adl_SelectionChangedFcn(hObject, eventdata, handles)

switch get(eventdata.NewValue, 'Tag') % Get Tag of selected object.
    
    case 'cooking'
        handles.NewGrasp.ADL = 'cooking';
        
    case 'housekeeping'
        handles.NewGrasp.ADL = 'housekeeping';
        
    case 'laundry'
        handles.NewGrasp.ADL = 'laundry';
end
guidata(hObject, handles);


% --- Executes when user attempts to close figure1. In order to be able to
% close current window by function call we are required to have following
% function.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%% CloseReqFCN
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
