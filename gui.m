



function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
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
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 18-Nov-2016 17:20:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
im = imread('index.jpg');
handles.plotline =[];
guidata(hObject,handles);
bg = axes('units','normalized','position',[0 0 1 1 ]);
uistack(bg,'bottom');
img = imread('back.jpg');
axes(bg);
imshow(img);
axes(handles.axes2);
imshow(im);








% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


b = get(handles.edit1,'String');
b = str2num(b);
%b = str2double(b);
%showfigure(adjMatrix, vertices, numOfDoors,b,img);
adjMatrix = handles.adjMatrix;
vertices =handles.vertices;
numOfDoors =handles.numOfDoors;
doors =handles.doors;
img = handles.img;
axes(handles.axes1);
imshow(img);hold on;
for i=1:numOfDoors
    txt = num2str(i);
    viscircles([(str2double(doors(i).x0)+str2double(doors(i).x1))/2,(str2double(doors(i).y0)+str2double(doors(i).y1))/2],50);
    text((str2double(doors(i).x0)+str2double(doors(i).x1))/2,(str2double(doors(i).y0)+str2double(doors(i).y1))/2,txt,'Color','blue');
    end
plotline =[];
if(b<=numOfDoors && b >0)
    for j=1:numOfDoors
        [~, route] = dijkstra(adjMatrix,b,j);
        s = size(route,2);
        t = rand(1,3);
        for i=1:(s)
            if (i+1 <= s)
                p1 = vertices(route(i),:);
                p2 = vertices(route(i+1),:);
                %axes(handles.axes1);
                plotline = [plotline;plot([p1(1),p2(1)],[p1(2),p2(2)],'Color',t,'LineWidth',1)];
            end
        end
    end
end
handles.plotline = plotline;
guidata(hObject,handles);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
hold off;
plotline = handles.plotline;
object = findobj(handles.axes1,'Type','image');
delete(object);
delete(plotline);
a = get(handles.listbox1,'Value');
if(a==1)
    img=imread('C:\Users\Ayush Agrawal\Desktop\BTP\file_1.tiff');
    s = xml2struct('C:\Users\Ayush Agrawal\Desktop\BTP\file_1.xml');
elseif(a==2)
    img=imread('C:\Users\Ayush Agrawal\Desktop\BTP\file_2.tiff');
    s = xml2struct('C:\Users\Ayush Agrawal\Desktop\BTP\file_2.xml');
elseif(a==3)
    img=imread('C:\Users\Ayush Agrawal\Desktop\BTP\file_3.tiff');
    s = xml2struct('C:\Users\Ayush Agrawal\Desktop\BTP\file_3.xml');
elseif(a==4)
    img=imread('C:\Users\Ayush Agrawal\Desktop\BTP\file_9.tiff');
    s = xml2struct('C:\Users\Ayush Agrawal\Desktop\BTP\file_9.xml');
else
    img=imread('C:\Users\Ayush Agrawal\Desktop\BTP\file_6.tiff');
    s = xml2struct('C:\Users\Ayush Agrawal\Desktop\BTP\file_6.xml');
end
blank = [];
axes(handles.axes1);
imshow(blank);
handles.img = img;
handles.s = s;
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles.img;
s = handles.s;
axes(handles.axes1);
imshow(img);
[adjMatrix, vertices, numOfDoors, doors] = working(img,s);
for i=1:numOfDoors
    txt = num2str(i);
    viscircles([(str2double(doors(i).x0)+str2double(doors(i).x1))/2,(str2double(doors(i).y0)+str2double(doors(i).y1))/2],50);
    text((str2double(doors(i).x0)+str2double(doors(i).x1))/2,(str2double(doors(i).y0)+str2double(doors(i).y1))/2,txt,'Color','blue');
end
handles.adjMatrix = adjMatrix;
handles.vertices =vertices;
handles.numOfDoors =numOfDoors;
handles.doors =doors;
guidata(hObject,handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
blank = [];
axes(handles.axes1);
hold off;
imshow(blank);
