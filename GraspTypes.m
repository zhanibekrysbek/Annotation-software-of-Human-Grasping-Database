function varargout = GraspTypes(varargin)
% GRASPTYPES MATLAB code for GraspTypes.fig
%      GRASPTYPES, the last window that will be called on the annotation
%      software used for annotating NU Human Grasping Database. 
%      
%      This particular gui will allow users to select one of 35 grasp types
%      listed in GRASP comprehensive taxonomy.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GraspTypes

% Last Modified by GUIDE v2.5 10-Jul-2015 20:25:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GraspTypes_OpeningFcn, ...
                   'gui_OutputFcn',  @GraspTypes_OutputFcn, ...
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


% --- Executes just before GraspTypes is made visible.
function GraspTypes_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GraspTypes (see VARARGIN)

% Choose default command line output for GraspTypes
handles.output = hObject;
% initialize img variable that will be passed to parent window
handles.img = uint8(255*ones(254,305));
% initialize 
handles.outputS = 'no grasp';
%Setting images into icons

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GraspTypes wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GraspTypes_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.outputS;
varargout{2} = handles.img;
delete(handles.figure1);



% --- Executes on button press in finish.
function finish_Callback(hObject, eventdata, handles)
% hObject    handle to finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes when selected object is changed in GraspChoose.
function GraspChoose_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in GraspChoose 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

imagePath = 'Pictures\';

switch get(eventdata.NewValue, 'Tag') % Get Tag of selected object.
 case 'LargeDiameter'
     handles.outputS = 'large diameter';
%      handles.img = handles.Imgs{1};

     handles.img = imread([imagePath 'i_' num2str(1) '_2.jpg']);
 case 'SmallDiameter'
     handles.outputS = 'small diameter';
%      handles.img = handles.Imgs{2};
     
     handles.img = imread([imagePath 'i_' num2str(2) '_2.jpg']);
 case 'MediumWrap'
     handles.outputS = 'medium wrap';
%      handles.img = handles.Imgs{3};
     
     handles.img = imread([imagePath 'i_' num2str(3) '_2.jpg']);
 case 'AdductedThumb'
     handles.outputS = 'adducted thumb';
%      handles.img = handles.Imgs{4};
     
     handles.img = imread([imagePath 'i_' num2str(4) '_2.jpg']);
 case 'LightTool'
     handles.outputS = 'light tool';
%      handles.img = handles.Imgs{5};
     
     handles.img = imread([imagePath 'i_' num2str(5) '_2.jpg']);
 case 'Prismatic4Finger'
     handles.outputS = 'prismatic 4 finger';
%      handles.img = handles.Imgs{6};
     
     handles.img = imread([imagePath 'i_' num2str(6) '_2.jpg']);
 case 'Prismatic3Finger'
     handles.outputS = 'prismatic 3 finger';
%      handles.img = handles.Imgs{7};
     
     handles.img = imread([imagePath 'i_' num2str(7) '_2.jpg']);
 case 'Prismatic2Finger'
     handles.outputS = 'prismatic 2 finger';
%      handles.img = handles.Imgs{8};
     
     handles.img = imread([imagePath 'i_' num2str(8) '_2.jpg']);
 case 'PalmarPinch'
     handles.outputS = 'palmar pinch';
%      handles.img = handles.Imgs{9};
     
     handles.img = imread([imagePath 'i_' num2str(9) '_2.jpg']);
 case 'PowerDisk'
     handles.outputS = 'power disk';
%      handles.img = handles.Imgs{10};
     
     handles.img = imread([imagePath 'i_' num2str(10) '_2.jpg']);
 case 'PowerSphere'
     handles.outputS = 'power sphere';
%      handles.img = handles.Imgs{11};
     
     handles.img = imread([imagePath 'i_' num2str(11) '_2.jpg']);
 case 'PrecisionDisk'
     handles.outputS = 'precision disk';
%      handles.img = handles.Imgs{12};
     
     handles.img = imread([imagePath 'i_' num2str(12) '_2.jpg']);
 case 'PrecisionSphere'
     handles.outputS = 'precision sphere';
%      handles.img = handles.Imgs{13};
     
     handles.img = imread([imagePath 'i_' num2str(13) '_2.jpg']);
 case 'Tripod'
     handles.outputS = 'tripod';
%      handles.img = handles.Imgs{14};
     
     handles.img = imread([imagePath 'i_' num2str(14) '_2.jpg']);
 case 'FixedHook'
     handles.outputS = 'fixed hook';
%      handles.img = handles.Imgs{15};
     
     handles.img = imread([imagePath 'i_' num2str(15) '_2.jpg']);
 case 'Lateral'
     handles.outputS = 'lateral';
%      handles.img = handles.Imgs{16};
     
     handles.img = imread([imagePath 'i_' num2str(16) '_2.jpg']);
 case 'IndexFingerExtension'
     handles.outputS = 'index finger extension';
%      handles.img = handles.Imgs{17};
     
     handles.img = imread([imagePath 'i_' num2str(17) '_2.jpg']);
 case 'ExtensionType'
     handles.outputS = 'extension type';
%      handles.img = handles.Imgs{18};
     
     handles.img = imread([imagePath 'i_' num2str(18) '_2.jpg']);
 case 'DistalType'
     handles.outputS = 'distal type';
%      handles.img = handles.Imgs{19};
     
     handles.img = imread([imagePath 'i_' num2str(19) '_2.jpg']);
 case 'WritingTripod'
     handles.outputS = 'writing tripod';
%      handles.img = handles.Imgs{20};
     
     handles.img = imread([imagePath 'i_' num2str(20) '_2.jpg']);
 case 'TripodVariation'
     handles.outputS = 'tripod variation';
%      handles.img = handles.Imgs{21};
     
     handles.img = imread([imagePath 'i_' num2str(21) '_2.jpg']);
 case 'ParallelExtension'
     handles.outputS = 'parallel extension';
%      handles.img = handles.Imgs{22};
     
     handles.img = imread([imagePath 'i_' num2str(22) '_2.jpg']);
 case 'AdductionGrip'
     handles.outputS = 'adduction grip';
%      handles.img = handles.Imgs{23};
     
     handles.img = imread([imagePath 'i_' num2str(23) '_2.jpg']);
 case 'TipPinch'
     handles.outputS = 'tip pinch';
%      handles.img = handles.Imgs{24};
     
     handles.img = imread([imagePath 'i_' num2str(24) '_2.jpg']);
 case 'LateralTripod'
     handles.outputS = 'lateral tripod';
%      handles.img = handles.Imgs{25};
     
     handles.img = imread([imagePath 'i_' num2str(25) '_2.jpg']);
 case 'Sphere4Finger'
     handles.outputS = 'sphere 4 finger';
%      handles.img = handles.Imgs{26};
     
     handles.img = imread([imagePath 'i_' num2str(26) '_2.jpg']);
 case 'Quadpod'
     handles.outputS = 'quadpod';
%      handles.img = handles.Imgs{27};
     
     handles.img = imread([imagePath 'i_' num2str(27) '_2.jpg']);
 case 'Sphere3Finger'
     handles.outputS = 'sphere 3 finger';
%      handles.img = handles.Imgs{28};
     
     handles.img = imread([imagePath 'i_' num2str(28) '_2.jpg']);
 case 'Stick'
     handles.outputS = 'stick';
%      handles.img = handles.Imgs{29};
     
     handles.img = imread([imagePath 'i_' num2str(29) '_2.jpg']);
 case 'Palmar'
     handles.outputS = 'palmar';
%      handles.img = handles.Imgs{30};
     
     handles.img = imread([imagePath 'i_' num2str(30) '_2.jpg']);
 case 'Ring'
     handles.outputS = 'ring';
%      handles.img = handles.Imgs{31};
     
     handles.img = imread([imagePath 'i_' num2str(31) '_2.jpg']);
 case 'Ventral'
     handles.outputS = 'ventral';
%      handles.img = handles.Imgs{32};
     
     handles.img = imread([imagePath 'i_' num2str(32) '_2.jpg']);
 case 'InferiorPincer'
     handles.outputS = 'inferior pincer';
%      handles.img = handles.Imgs{33};
     
     handles.img = imread([imagePath 'i_' num2str(33) '_2.jpg']);
 case 'push' 
     handles.outputS = 'push';
     handles.img = imread([imagePath 'i_' num2str(34) '_2.jpg']);
     
 case 'lift' 
     handles.outputS = 'lift';
     handles.img = imread([imagePath 'i_' num2str(35) '_2.jpg']);
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function GraspChoose_CreateFcn(~, ~, ~)
% hObject    handle to GraspChoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
else
% Hint: delete(hObject) closes the figure
delete(hObject);
end
