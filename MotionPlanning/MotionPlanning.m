function varargout = MotionPlanning(varargin)
% MOTIONPLANNING MATLAB code for MotionPlanning.fig
%      MOTIONPLANNING, by itself, creates a new MOTIONPLANNING or raises the existing
%      singleton*.
%
%      H = MOTIONPLANNING returns the handle to a new MOTIONPLANNING or the handle to
%      the existing singleton*.
%
%      MOTIONPLANNING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTIONPLANNING.M with the given input arguments.
%
%      MOTIONPLANNING('Property','Value',...) creates a new MOTIONPLANNING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotionPlanning_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotionPlanning_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MotionPlanning

% Last Modified by GUIDE v2.5 26-Apr-2015 00:30:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotionPlanning_OpeningFcn, ...
                   'gui_OutputFcn',  @MotionPlanning_OutputFcn, ...
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


% --- Executes just before MotionPlanning is made visible.
function MotionPlanning_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotionPlanning (see VARARGIN)

%clean up axes
set(handles.axes1,'Xlim',[0,1]);
set(handles.axes1,'Ylim',[0,1]);
set(handles.axes1,'XTick',(0:.2:1));
set(handles.axes1,'YTick',(0:.2:1));
set(handles.axes1,'XTickLabel',['  0';'100';'200';'300';'400';'500']);
set(handles.axes1,'YTickLabel',['  0';'100';'200';'300';'400';'500']);
% Choose default command line output for MotionPlanning
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MotionPlanning wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MotionPlanning_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in solve.
function solve_Callback(hObject, eventdata, handles)
% hObject    handle to solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);

div = 1/500;
%use data in table to draw boxes + start & finish points
%tableData Format:
%       Start  Finish  Block-1     Block-2     Block-3
%   X
%   Y
tableData = get(handles.uitable, 'data');
hold off
gen_point(tableData(1,1)*div,tableData(2,1)*div,3*div);
hold on
text((tableData(1,1)-13)*div, (tableData(2,1)+10)*div,'Start');
gen_point(tableData(1,2)*div,tableData(2,2)*div,3*div);
text((tableData(1,2)-15)*div, (tableData(2,2)+10)*div,'Finish');
gen_block(tableData(1,3)*div,tableData(2,3)*div,200*div,200*div,[.5 .5 .5],0.5);
gen_block(tableData(1,4)*div,tableData(2,4)*div,150*div,150*div,[.5 .5 .5],0.5);
gen_block(tableData(1,5)*div,tableData(2,5)*div,100*div,100*div,[.5 .5 .5],0.5);

%error check to make sure start + finish are outside of obstacles
%(otherwise solution is impossible) and print error message if neccesary
error = false;
startInsideBlock1 = tableData(1,1) > tableData(1,3) & tableData(1,1) < tableData(1,3)+200 & tableData(2,1) > tableData(2,3) & tableData(2,1) < tableData(2,3)+200;
startInsideBlock2 = tableData(1,1) > tableData(1,4) & tableData(1,1) < tableData(1,4)+150 & tableData(2,1) > tableData(2,4) & tableData(2,1) < tableData(2,4)+150;
startInsideBlock3 = tableData(1,1) > tableData(1,5) & tableData(1,1) < tableData(1,5)+100 & tableData(2,1) > tableData(2,5) & tableData(2,1) < tableData(2,4)+100;
endInsideBlock1 = tableData(1,2) > tableData(1,3) & tableData(1,2) < tableData(1,3)+200 & tableData(2,2) > tableData(2,3) & tableData(2,2) < tableData(2,3)+200;
endInsideBlock2 = tableData(1,2) > tableData(1,4) & tableData(1,2) < tableData(1,4)+150 & tableData(2,2) > tableData(2,4) & tableData(2,2) < tableData(2,4)+150;
endInsideBlock3 = tableData(1,2) > tableData(1,5) & tableData(1,2) < tableData(1,5)+100 & tableData(2,2) > tableData(2,5) & tableData(2,2) < tableData(2,4)+100;
if(startInsideBlock1 || startInsideBlock2 || startInsideBlock3 || endInsideBlock1 || endInsideBlock2 || endInsideBlock3)
    error = true;
end
if(error)
    set(handles.feedbackText,'ForegroundColor','r');
    set(handles.feedbackText,'String','Start/Finish Points cannot be inside an obstacle!');
    %clean up axes
    set(handles.axes1,'Xlim',[0,1]);
    set(handles.axes1,'Ylim',[0,1]);
    set(handles.axes1,'XTick',(0:.2:1));
    set(handles.axes1,'YTick',(0:.2:1));
    set(handles.axes1,'XTickLabel',['  0';'100';'200';'300';'400';'500']);
    set(handles.axes1,'YTickLabel',['  0';'100';'200';'300';'400';'500']);
    % Update handles structure
    guidata(hObject, handles);
    return;
else
    set(handles.feedbackText,'ForegroundColor','g');
    set(handles.feedbackText,'String','');
end

%vertical cell division, sweep left to right 2 divisions per block(l+r)
%points structure
% [1 2 3]
% [x y deltaY isRight]
% use deltaY to get top point of that block( x,y+deltaY)
points = [tableData(1,3) tableData(2,3) 200 false 1; tableData(1,3)+200 tableData(2,3) 200 true 1;tableData(1,4) tableData(2,4) 150 false 2; tableData(1,4)+150 tableData(2,4) 150 true 2; tableData(1,5) tableData(2,5) 100 false 3; tableData(1,5)+100 tableData(2,5) 100 true 3];
points = sortrows(points,1);
regions = [gen_region_struct('C1',0,0,500,500,[])];
for i=1:size(points)
    %collision detection of line vs blocks
    %collisions contains distance from point of collision
    collisionsUp = [500];
    collisionsDown = [0];
    blockIndices = [3 4 5];
    blockSizes = [200 150 100];
    for j=1:3
        if(points(i,5)~=j)  %don't collide with yourself.
            %check block
            if(points(i,1) >= tableData(1,blockIndices(j)) && points(i,1) <= tableData(1,blockIndices(j))+blockSizes(j))
                %collides with block 1 somewhere.
                if(tableData(2,blockIndices(j))+blockSizes(j) < points(i,2)) %if topOther < botThis
                    collisionsDown = [collisionsDown tableData(2,blockIndices(j))+blockSizes(j)];
                else if(tableData(2,blockIndices(j)) <= points(i,2))        %if botOther < botThis, no line in this case
                    collisionsDown = [collisionsDown points(i,2)];
                    end
                end
                if(tableData(2,blockIndices(j)) > points(i,2)+points(i,3)) %if botOther > topThis
                    collisionsUp = [collisionsUp tableData(2,blockIndices(j))];
                else if(tableData(2,blockIndices(j))+blockSizes(j) >= points(i,2)+points(i,3)) %if topOther > topThis
                    collisionsUp = [collisionsUp points(i,2)+points(i,3)];
                %else block is fully inside of me, i can ignore it.
                    end
                end
            end
        end
    end
    collisionsDown = sort(collisionsDown, 'descend');
    collisionsUp = sort(collisionsUp);
    %draw cell division
    plot([points(i,1)*div points(i,1)*div],[collisionsDown(1)*div collisionsUp(1)*div]);
    %region splitting
    %use str2num(name) to get int, use sprintf(num) to get string back
    %check if collision line endpoints are on region boundry
    origRegionSize = size(regions);
    upDone = false;
    downDone = false;
    for j=1:origRegionSize(1)
        %check if x of line is within region x range
        if(points(i,1) >= regions(j).x && points(i,1) <= regions(j).x+regions(j).w)
            %check if top point is on the y
            if(upDone && downDone)
                break;
            end
            if(collisionsUp(1) == regions(j).y + regions(j).h)
                %split region
                rSize = size(regions);
                regions(j).w = points(i,1)-regions(j).x;
                if(points(i,4) && ~downDone && collisionsUp(1)-collisionsDown(1)>0 && 500 - points(i,1)>0)
                    regions = [regions; gen_region_struct(strcat('C',num2str(rSize(1)+1)),points(i,1), collisionsDown(1), 500 - points(i,1), collisionsUp(1)-collisionsDown(1), [j])];
                    regions(j).neighbors = [regions(j).neighbors; rSize(1)+1];
                else if(~(points(i,4)) && collisionsUp(1)-(points(i,2)+points(i,3))>0 && 500 - points(i,1)>0)
                    %left side upper
                    regions = [regions; gen_region_struct(strcat('C',num2str(rSize(1)+1)),points(i,1), points(i,2)+points(i,3), 500 - points(i,1), collisionsUp(1)-(points(i,2)+points(i,3)), [j])];
                    regions(j).neighbors = [regions(j).neighbors; rSize(1)+1];
                    else
                        %right side, next region been made already, just ensure neighbor setups
                        regions(j).neighbors = [regions(j).neighbors; rSize(1)];
                        regions(rSize(1)).neighbors = [regions(rSize(1)).neighbors; j];
                    end
                end
                upDone = true;
            end
            if(upDone && downDone)
                break;
            end
            %check if bottom point is on the y
            if(collisionsDown(1) == regions(j).y)
                rSize = size(regions);
                regions(j).w = points(i,1)-regions(j).x;
                if(points(i,4) && ~upDone && collisionsUp(1)-collisionsDown(1)>0 && 500 - points(i,1)>0)
                    regions = [regions; gen_region_struct(strcat('C',num2str(rSize(1)+1)),points(i,1), collisionsDown(1), 500 - points(i,1), collisionsUp(1)-collisionsDown(1), [j])];
                    regions(j).neighbors = [regions(j).neighbors; rSize(1)+1];
                else if(~(points(i,4)) && points(i,2)-collisionsDown(1)>0 && 500 - points(i,1)>0)
                    regions = [regions; gen_region_struct(strcat('C',num2str(rSize(1)+1)),points(i,1), collisionsDown(1), 500 - points(i,1), points(i,2)-collisionsDown(1), [j])];
                    regions(j).neighbors = [regions(j).neighbors; rSize(1)+1];
                    else
                        %right side, next region been made already, just ensure neighbor setups
                        regions(j).neighbors = [regions(j).neighbors; rSize(1)];
                        regions(rSize(1)).neighbors = [regions(rSize(1)).neighbors; j];
                    end
                end
                downDone = true;
            end
        end
    end
end
for i=1:size(regions)
    regions(i)
    text((regions(i).x + regions(i).w/2 - 7)*div,(regions(i).y + regions(i).h/2)*div,regions(i).name);
end
%DFS on region tree to find solution
%find out what region start is in
startIndex = 0;
goalIndex = 0;
for i=1:size(regions)
    if(tableData(1,1) >= regions(i).x && tableData(1,1) <= regions(i).x+regions(i).w && tableData(2,1) >= regions(i).y && tableData(2,1) <= regions(i).y+regions(i).h)
        startIndex = i;
        break;
    end
end
for i=1:size(regions)
    if(tableData(1,2) >= regions(i).x && tableData(1,2) <= regions(i).x+regions(i).w && tableData(2,2) >= regions(i).y && tableData(2,2) <= regions(i).y+regions(i).h)
        goalIndex = i;
        break;
    end
end
%error check if we couldn't find regions here.
if(startIndex == 0 || goalIndex == 0)
    set(handles.feedbackText,'ForegroundColor','r');
    set(handles.feedbackText,'String','Could not find regions for Start/Finish Points!');
    %clean up axes
    set(handles.axes1,'Xlim',[0,1]);
    set(handles.axes1,'Ylim',[0,1]);
    set(handles.axes1,'XTick',(0:.2:1));
    set(handles.axes1,'YTick',(0:.2:1));
    set(handles.axes1,'XTickLabel',['  0';'100';'200';'300';'400';'500']);
    set(handles.axes1,'YTickLabel',['  0';'100';'200';'300';'400';'500']);
    % Update handles structure
    guidata(hObject, handles);
    return;
end
path=[startIndex];
path = DFS(regions,startIndex,path, goalIndex);
pathString = strcat('Possible Pathway=',regions(path(1)).name);
pFinalSize = size(path);
for i=2:pFinalSize(1)
    pathString = strcat(pathString, strcat('>',regions(path(i)).name));
end
set(handles.feedbackText, 'ForegroundColor', 'b');
set(handles.feedbackText, 'String', pathString);
%draw lines on axes to display path
lastPoint = [tableData(1,1) tableData(2,1)];
lastRegion = path(1);
for i=2:pFinalSize(1)
    %find overlapping segment of regions, we know there is one.
    if(path(i) > lastRegion)    %moving to the right using left end of next region
        if(regions(path(i)).y+regions(path(i)).h > regions(lastRegion).y+regions(lastRegion).h) %if top new > top old
            midpoint = [regions(path(i)).x regions(path(i)).y+((regions(lastRegion).y+regions(lastRegion).h-regions(path(i)).y))/2];
        else if(regions(path(i)).y > regions(lastRegion).y)%if bottom new > bottom old
            midpoint = [regions(path(i)).x regions(lastRegion).y+regions(lastRegion).h-((regions(lastRegion).y+regions(lastRegion).h-regions(path(i)).y))/2];
        else
            midpoint = [regions(path(i)).x regions(lastRegion).y+((regions(path(i)).y+regions(path(i)).h-regions(lastRegion).y))/2];
            end
        end
    else %moving to the left use right end of next region
        if(regions(path(i)).y+regions(path(i)).h > regions(lastRegion).y+regions(lastRegion).h) %if top new > top old
            midpoint = [regions(path(i)).x+regions(path(i)).w regions(path(i)).y+((regions(lastRegion).y+regions(lastRegion).h-regions(path(i)).y))/2];
        else if(regions(path(i)).y > regions(lastRegion).y)%if bottom new > bottom old, topOld - (topOld-botNew)/2
            midpoint = [regions(path(i)).x+regions(path(i)).w regions(lastRegion).y+regions(lastRegion).h-((regions(lastRegion).y+regions(lastRegion).h-regions(path(i)).y))/2];
        else
            midpoint = [regions(path(i)).x+regions(path(i)).w regions(lastRegion).y+((regions(path(i)).y+regions(path(i)).h-regions(lastRegion).y))/2];
            end
        end
    end
    plot([lastPoint(1)*div midpoint(1)*div],[lastPoint(2)*div midpoint(2)*div], 'black --');
    lastRegion = path(i);
    lastPoint = midpoint;
end
plot([lastPoint(1)*div tableData(1,2)*div], [lastPoint(2)*div tableData(2,2)*div], 'black --');
%clean up axes
set(handles.axes1,'Xlim',[0,1]);
set(handles.axes1,'Ylim',[0,1]);
set(handles.axes1,'XTick',(0:.2:1));
set(handles.axes1,'YTick',(0:.2:1));
set(handles.axes1,'XTickLabel',['  0';'100';'200';'300';'400';'500']);
set(handles.axes1,'YTickLabel',['  0';'100';'200';'300';'400';'500']);
% Update handles structure
guidata(hObject, handles);

function path = DFS(regions,currIndex,path,goalIndex)
nSize = size(regions(currIndex).neighbors);
%create sorted neighbor list (based on index distance from goalIndex)
neighbors = [];
for i=1:nSize(1)
    neighbors = [neighbors; abs(regions(currIndex).neighbors(i)-goalIndex) regions(currIndex).neighbors(i)]; 
end
neighbors = sortrows(neighbors,1);
for i=1:nSize(1)
    %quick stop if next is goal
    if(neighbors(i,2)==goalIndex)
        path = [path; neighbors(i,2)];
        return;
    end
    %check if next has been visited (in path already)
    visited = false;
    pSize = size(path);
    for j=1:pSize(1)
        if(path(j) == neighbors(i,2))
            visited = true;
            break;
        end
    end
    if(~visited)    %if not visited, recur
        possiblePath = DFS(regions, neighbors(i,2), [path; neighbors(i,2)], goalIndex);
        if(possiblePath(end)==goalIndex)
            path = possiblePath;
            return;
        end
    end
end

function h = gen_point(x,y,r)
%x = x loc
%y = y loc
%r = radius
%c = color
angle = 0:0.01:2*pi;
xp = r * cos(angle);
yp = r * sin(angle);
h = fill(x + xp, y + yp, 'black');

%[x,y] = lower left corner of block
function h = gen_block(x, y, w, h, c, o)
vert = [x y; x+w y; x+w y+h; x y+h];
fac = [1 2 3 4];
h = patch('Faces',fac,'Vertices',vert,'FaceColor',c,'FaceAlpha',o);


function s = gen_region_struct(name, x, y, w, h, neighbors)
%name = label for region
%(x,y) = bottom left corner of region
%(w,h) = width/height of region
% neighbors = [] of connected regions
s = struct('name',name,'x',x,'y',y,'w',w,'h',h, 'neighbors', neighbors);

% --- Executes when entered data in editable cell(s) in uitable.
function uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
div = 1/500;
%use data in table to draw boxes + start & finish points
%tableData Format:
%       Start  Finish  Block-1     Block-2     Block-3
%   X
%   Y
tableData = get(handles.uitable, 'data');
hold off
gen_point(tableData(1,1)*div,tableData(2,1)*div,3*div);
hold on
text((tableData(1,1)-13)*div, (tableData(2,1)+10)*div,'Start');
gen_point(tableData(1,2)*div,tableData(2,2)*div,3*div);
text((tableData(1,2)-15)*div, (tableData(2,2)+10)*div,'Finish');
gen_block(tableData(1,3)*div,tableData(2,3)*div,200*div,200*div,[.5 .5 .5],0.5);
gen_block(tableData(1,4)*div,tableData(2,4)*div,150*div,150*div,[.5 .5 .5],0.5);
gen_block(tableData(1,5)*div,tableData(2,5)*div,100*div,100*div,[.5 .5 .5],0.5);
set(handles.feedbackText,'ForegroundColor','g');
set(handles.feedbackText,'String','');
%clean up axes
set(handles.axes1,'Xlim',[0,1]);
set(handles.axes1,'Ylim',[0,1]);
set(handles.axes1,'XTick',(0:.2:1));
set(handles.axes1,'YTick',(0:.2:1));
set(handles.axes1,'XTickLabel',['  0';'100';'200';'300';'400';'500']);
set(handles.axes1,'YTickLabel',['  0';'100';'200';'300';'400';'500']);
% Update handles structure
guidata(hObject, handles);
