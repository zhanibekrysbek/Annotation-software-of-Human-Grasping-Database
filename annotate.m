function varargout = annotate(varargin)
% ANNOTATE MATLAB code for annotate.fig
%      ANNOTATE, by itself, creates a new ANNOTATE or raises the existing
%      singleton*.
%
%      H = ANNOTATE returns the handle to a new ANNOTATE or the handle to
%      the existing singleton*.
%
%      ANNOTATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANNOTATE.M with the given input arguments.
%
%      ANNOTATE('Property','Value',...) creates a new ANNOTATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before annotate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to annotate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help annotate

% Last Modified by GUIDE v2.5 12-Jun-2017 15:17:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @annotate_OpeningFcn, ...
    'gui_OutputFcn',  @annotate_OutputFcn, ...
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

% --- Executes just before annotate is made visible.
function annotate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to annotate (see VARARGIN)

% Initialize variables
handles.output = hObject;
handles.vidGopro = [];      % Video object handle
handles.posGopro = 1;       % current frame variable
handles.jumpConst = 15;     % 

handles.sequence.seqNum = 0;
handles.sequence.lastFrame = 0;

handles.annotatedData = [];

handles.videoFileGopro = '';
handles.videoFileGoproPath = '';


storageFileName_Callback(hObject, eventdata, handles);
handles.currentGraspIndex = 1;

set(handles.addGrasp, 'enable','off');
set(handles.closeSequence, 'enable', 'off')
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = annotate_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, ~, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.videoFileGoproPath = get(handles.pathGopro,'String');
[~,name,ext] = fileparts(handles.videoFileGoproPath);

handles.videoFileGopro = [name ext];

handles.vidGopro = VideoReader(handles.videoFileGoproPath);
handles.posGopro = 1;
set(handles.frameCount, 'String', sprintf('%d/%d', handles.posGopro, handles.vidGopro.NumberOfFrames));

handles.videoFileGopro = name;
set(handles.fileName, 'String', handles.videoFileGopro);
showGoproFrame(handles, handles.posGopro);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function StartID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pathGopro_Callback(~, ~, ~)
% hObject    handle to pathGopro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathGopro as text
%        str2double(get(hObject,'String')) returns contents of pathGopro as a double


% --- Executes during object creation, after setting all properties.
function pathGopro_CreateFcn(hObject, ~, ~)
% hObject    handle to pathGopro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in play_pause.
function play_pause_Callback(hObject, ~, handles)
% hObject    handle to play_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.vidGopro)
    
    if get(hObject,'Value')
        set(hObject,'String', 'Pause');
    else
        set(hObject,'String', 'Play');
    end
    
    while get(hObject,'Value') && handles.posGopro < handles.vidGopro.NumberOfFrames
        showGoproFrame(handles, handles.posGopro);
        pause(0.001);
        handles.posGopro = handles.posGopro + 1;
        if handles.posGopro == handles.vidGopro.NumberOfFrames
            showGoproFrame(handles, handles.posGopro);
            set(hObject,'String', 'Play', 'Value', false);
        end
    end
else
    msgbox('Please load a video','Video is missing','error');
end

guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of play_pause


% --- Executes on button press in forwardJump.
function forwardJump_Callback(hObject, ~, handles)
% hObject    handle to forwardJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.posGopro + handles.vidGopro.FrameRate * 0.5 <= handles.vidGopro.NumberOfFrames
    handles.posGopro = handles.posGopro + handles.vidGopro.FrameRate * 0.5;
    handles.posGopro = round(handles.posGopro);
    showGoproFrame(handles, handles.posGopro);
else
    handles.posGopro = handles.vidGopro.NumberOfFrames;
    showGoproFrame(handles, handles.posGopro);
end
guidata(hObject, handles);


% --- Executes on button press in backJump.
function backJump_Callback(hObject, ~, handles)
% hObject    handle to backJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This method allows video roll backJump to 2 secs

if handles.posGopro - handles.vidGopro.FrameRate * 0.5 >= 1
    handles.posGopro = handles.posGopro - handles.vidGopro.FrameRate * 0.5;
    handles.posGopro = round(handles.posGopro);
    showGoproFrame(handles, handles.posGopro);
else
    handles.posGopro = 1;
    showGoproFrame(handles, handles.posGopro);
end

guidata(hObject, handles);


% --- Executes on button press in takeFrame.
function takeFrame_Callback(hObject, ~, handles)
% hObject    handle to takeFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.posGopro - 1 >=1
    handles.posGopro = handles.posGopro - 1;
    showGoproFrame(handles, handles.posGopro);
end

guidata(hObject, handles);



% --- Executes on button press in addFrame.
function addFrame_Callback(hObject, ~, handles)
% hObject    handle to addFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.posGopro + 1 <= handles.vidGopro.NumberOfFrames
    handles.posGopro = handles.posGopro + 1;
    showGoproFrame(handles, handles.posGopro);
end
guidata(hObject, handles);

% --- Executes on button press in stop.
function stop_Callback(hObject, ~, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.posGopro = 1;
showGoproFrame(handles, handles.posGopro);
guidata(hObject,handles);


% --- Executes on slider movement.
function slider_Callback(hObject, ~, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r = get(hObject,'Value');
handles.posGopro = round(r*handles.vidGopro.NumberOfFrames);
if handles.posGopro == 0
    handles.posGopro = 1;
end
showGoproFrame(handles, handles.posGopro);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, ~, ~)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in OpenFile.
function OpenFile_Callback(hObject, ~, handles)
% hObject    handle to OpenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open(get(handles.storageFileName,'String'));
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function jumpGopro_CreateFcn(hObject, ~, ~)
% hObject    handle to jumpGopro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function storageFileName_CreateFcn(hObject, ~, ~)
% hObject    handle to storageFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function startFrame_CreateFcn(hObject, ~, ~)
% hObject    handle to startFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function endFrame_CreateFcn(hObject, ~, ~)
% hObject    handle to endFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function storageFileName_Callback(~, eventdata, handles)
% hObject    handle to storageFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

outputFileReload_Callback(handles.outputFileReload, eventdata, handles)



function jumpGopro_Callback(hObject, ~, handles)
% hObject    handle to jumpGopro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
k = str2double(get(hObject,'String'));
if k >= 1 && k <= handles.vidGopro.NumberOfFrames
    handles.posGopro = k;
    showGoproFrame(handles, handles.posGopro);
else
    msgbox('You entered invalid number', 'Wrong Input','warn','modal');
end
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over jumpGopro.
function jumpGopro_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to jumpGopro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on jumpGopro and none of its controls.
function jumpGopro_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to jumpGopro (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(~, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in startFrameEnter.
function startFrameEnter_Callback(hObject, ~, handles)
% hObject    handle to startFrameEnter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.startFrame, 'String', num2str(handles.posGopro));
handles.toString = '';
guidata(hObject, handles);


% --- Executes on button press in endFrameEnter.
function endFrameEnter_Callback(hObject, ~, handles)
% hObject    handle to endFrameEnter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.endFrame, 'String', num2str(handles.posGopro));
handles.toString = '';
guidata(hObject, handles);




% Helper function. It is responsible to show the specified frame and update
% relating information.
function outPut = showGoproFrame(handles, frameNum)
snapshot2 = read(handles.vidGopro, frameNum);
set(handles.frameCount, 'String', sprintf('%d/%d', frameNum, handles.vidGopro.NumberOfFrames) );                       %imresize(snapshot, handles.sc);
axes(handles.axes1);
imshow(snapshot2);
set(handles.slider, 'Value', (frameNum/handles.vidGopro.NumberOfFrames));
outPut = handles;


% --- Executes on button press in outputFileReload.
function outputFileReload_Callback(hObject, ~, handles)
% hObject    handle to outputFileReload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

outputFile = get(handles.storageFileName,'String');

FID = fopen(outputFile, 'r');                              % opens a csv file
if FID ~= -1
    fsp = repmat('%s', [1,13]);
    C = textscan(FID, fsp,'delimiter',',');
    fclose(FID);
    
    % handles.annotatedFields = {'ID';'Subject';'Grasp';'ADL';'Video';...
    % 'StartFrame';'EndFrame';'OppType';'PIP';'VirtualFingers';'Thumb';'Duration';'Properties'};
    
    f = {'GraspID', 'SubjectName','GraspName', 'FieldOfADL','VideoFileName',...
        'StartFrame', 'EndFrame', 'OppType', 'PIP', 'VirtFingers', 'ThumbPos', 'Duration', 'Sequence'};
    PreviousData = cell2struct(C,f,2);
    
    if  ~isempty(PreviousData.GraspID)
        id = PreviousData.GraspID(end);
        id = str2double(id{1}(6:end));
        set(handles.StartID,'String', id + 1);
    else
        set(handles.StartID,'String', 1);
    end
    
else
    set(handles.StartID, 'String', 1);
end
guidata(hObject, handles);



% --- Executes on button press in browse_video.
function browse_video_Callback(hObject, ~, handles)
% hObject    handle to browse_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ name, path, ~] = uigetfile('*.mp4');

if name ~= 0
    handles.videoFileGoproPath = [path '\' name];
    [~,name,~] = fileparts(name);
    
    set(handles.pathGopro,'String', handles.videoFileGoproPath);
    handles.videoFileGopro = name;
    
    set(handles.fileName, 'String', handles.videoFileGopro);
    
    handles.vidGopro = VideoReader(handles.videoFileGoproPath);
    handles.posGopro = 1;
    set(handles.frameCount, 'String', sprintf('%d/%d',handles.posGopro,handles.vidGopro.NumberOfFrames));
    showGoproFrame(handles, handles.posGopro);
end
guidata(hObject, handles);


% --- Executes on button press in newSequence.
function newSequence_Callback(hObject, ~, handles)
% hObject    handle to newSequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

startGopro = str2double(get(handles.startFrame, 'String'));
endGopro = str2double(get(handles.endFrame, 'String'));

if startGopro < endGopro
    
    % ID,Subject,Grasp,ADL,Video,StartFrame,EndFrame,OppType,PIP,VirtualFingers,Thumb,Duration
    C = strsplit(handles.vidGopro.Name, '_');
    temp.ADL = 'cooking';
    temp.Subject = [C{1} ' ' C{2}];
    temp.Video = handles.vidGopro.Name;
    temp.StartFrame = num2str(startGopro);
    temp.EndFrame = num2str(endGopro);
    temp.Duration = sprintf('%.3g',(endGopro-startGopro)/30);
    temp.SequenceNum = '0';
    
    nextID = str2double(get(handles.StartID, 'String'));
    
    temp.ID = sprintf('Grasp%.5d', nextID);
    
    [~, res] = SaveAnnotation(temp, get(handles.storageFileName, 'String'));
    
    if res == 1
        % if success
        set(handles.StartID, 'String', num2str(nextID + 1));
        handles.sequence.seqNum = 1;
        handles.sequence.lastFrame = endGopro;
        
        set(hObject, 'enable','off');
        set(handles.addGrasp, 'enable','on');
        set(handles.closeSequence, 'enable','on');
        
        set(handles.startFrame, 'String', num2str(handles.sequence.lastFrame + 1 ));
        set(handles.endFrame, 'String', '');
        
        set(handles.sequenceShow, 'String', '[... ,');
    end
else
    msgbox('Look carefully to frame numbers...','Invalid start and end frames!','error')
end

% if res
%     set(hObject, 'enable','off');
% else
%     set(hObject, 'enable','on');
% end

guidata(hObject, handles);



% --- Executes on button press in addGrasp.
function addGrasp_Callback(hObject, ~, handles)
% hObject    handle to addGrasp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


startGopro = str2double(get(handles.startFrame, 'String'));
endGopro = str2double(get(handles.endFrame, 'String'));

if startGopro < endGopro
    
       
    C = strsplit(handles.vidGopro.Name, '_');
    temp.ADL = 'cooking';
    temp.Subject = [C{1} ' ' C{2}];
    temp.Video = handles.vidGopro.Name;
    temp.StartFrame = num2str(startGopro);
    temp.EndFrame = num2str(endGopro);
    temp.Duration = sprintf('%.3g',(endGopro-startGopro)/30);
    temp.SequenceNum = num2str(handles.sequence.seqNum);
    
    nextID = str2double(get(handles.StartID, 'String'));
    
    temp.ID = sprintf('Grasp%.5d', nextID);
    
    [~, res] = SaveAnnotation(temp, get(handles.storageFileName, 'String'));
    
    if res == 1
        % if success
        set(handles.StartID, 'String', num2str(nextID + 1));
        handles.sequence.seqNum = handles.sequence.seqNum + 1;
        handles.sequence.lastFrame = endGopro;


        set(handles.newSequence, 'enable','off');
        set(handles.addGrasp, 'enable','on');

        set(handles.startFrame, 'String', num2str(handles.sequence.lastFrame + 1 ));
        set(handles.endFrame, 'String', '');

        prev = get(handles.sequenceShow, 'String');
        set(handles.sequenceShow, 'String', [prev '... ,']);
    end
else
    msgbox('Look carefully to frame numbers...','Invalid start and end frames!','error')
end

res

guidata(hObject, handles);


% --- Executes on button press in closeSequence.
function closeSequence_Callback(hObject, ~, handles)
% hObject    handle to closeSequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.sequence.seqNum = 0;
set(handles.newSequence, 'enable','on');
set(handles.addGrasp, 'enable','off');


set(handles.startFrame, 'String', '');
set(handles.endFrame, 'String', '');


prev = get(handles.sequenceShow, 'String');
set(handles.sequenceShow, 'String', [prev(1:end-1) ']']);

guidata(hObject, handles);
