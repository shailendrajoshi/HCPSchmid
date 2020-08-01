function [  ] = mainApp(  )

% pre-defined values. Feel free to edit this block.

% default c to a value
ca = 1.633;

% size of each ball of atom.
atomSize = .1;

% color of atoms, different for layer A and layer B. The color is in rgb format.
atomColorA = [0.6   0.396078431372549   0.082352941176471]; % golden brown
atomColorB = [1 0 1]; % magenta

% axis properties.
axisSize = 1.3;
axisColor = [.6 .6 .6]; % grey

% color of different components of plot.
intersectionColor = [0 1 0]; % green
slipDirectionColor = [1 0 0]; % red
loadDirectionColor = [1 .647 0]; % orange
planeNormalColor = [0 0 1]; % blue
planeColor = [.6 .6 .6]; % grey.
planeTransparency = .5; % from 0 to 1, 0 being completely transparent.


figureTitle = 'hcp';
maxLoad = 4; % maximum number of load allowed. Anything more than 4 will have to resize (enlarge) the top left box.
%%%%%%



figure('position', [40 80 1024 640], 'name', figureTitle, 'numbertitle', 'off',...
    'color', 'w','menubar','none','ToolBar', 'figure','tag','hcp','resizeF',@figureResize, 'tag','figure');
clear figureTitle Callback

% delete unnecessary toolbars, keeping those that are useful.
deleteToolBars();

axes('units', 'pix', 'position', [0 40 729 430], ...
    'YTickLabelm','m','xticklabelm','m','zticklabelm','m');

% caRatio and atomSize and atom colors stored in the figure appdata.
setappdata(gcf,'caRatio',ca); % caRatio calls for a function to retrieve this data.
setappdata(gcf,'atomSize',atomSize);
setappdata(gcf,'atomColorA',atomColorA);
setappdata(gcf,'atomColorB',atomColorB);

% axisSize and axisColor stored in axes appdata.
setappdata(gca,'axisSize',axisSize);
setappdata(gca,'axisColor',axisColor);
setappdata(gca,'slipDirectionColor', slipDirectionColor);
setappdata(gca,'loadDirectionColor', loadDirectionColor);
setappdata(gca,'planeNormalColor', planeNormalColor);
setappdata(gca,'intersectionColor', intersectionColor);
setappdata(gca,'planeColor',planeColor);
setappdata(gca,'planeTransparency',planeTransparency);
clear ca atomSize axisSize axisColor intersectionColor slipDirectionColor loadDirectionColor planeNormalColor planeColor planeTransparency atomColorA atomColorB

defineAxes();

% left top group. uipanels are for visual appeal and relative position
% coherence.
shade = uipanel('units','pixels','position',[0 450 10000 190],'bordert','none','tag','shade','visible','off');
panelLoadOuter = uipanel(shade,'units','pixels','position',[10 10 185 170],'bordert','beveledout','borderw',2);
panelLoad = uipanel(panelLoadOuter,'units','pixels','position',[10 10 165 150],'title','Load Direction','tag','left');

setappdata(panelLoad,'maxLoad',maxLoad);

% Load Direction input box. There is 1 load by default.
hEdit(1) = edit_LoadDirection(); % Load direction editable textbox.
set(hEdit(1),'visible','on');

% below is the number '#1' that appears before the textbox. Invisible if there is only one load.
hNo(1) = uicontrol(panelLoad,'style','text','string','#1','posi',[10 77 20 20],'visible','off');

% below is the cross button appearing at right side, to remove a load.
% Invisible if there is only one load. The function also defines the callback of the cross button.
hClose(1) = removeLoad();

handleMatrix = [hEdit hNo hClose]; % this matrix containing handles (to numbering, editable textbox, and cross button) is stored in 'userdata' of the panel object, for manipulation of addLoad() and removeLoad() functions.
setappdata(panelLoad,'handleMatrix',handleMatrix);
setappdata(panelLoad,'NumofLoad',1); % number of load is stored here.
addLoad(); % creates the Add Load button. Also defines its callback.


% 'Calculate' button. See its callback reconstruction().
uicontrol(panelLoad,'style','push','string','Calculate','tag','calculate','position',[22 10 120 25],...
    'callback','reconstruction()','visible','on','tooltip',sprintf('Update Schmit factors after edit/add/remove load.\nUpdate Schmit factors and plot drawings after change of c/a ratio.'));
set(shade,'visible','on');
clear C panelLoad panelLoadOuter


% settings.
settingsOuter = uipanel(shade,'units','pix','position',[200 10 250 170],'bordert','beveledout','borderw',2);
settings = uipanel(settingsOuter,'units','pixels','position',[10 10 230 150],'title','Settings','tag','settings');
clear settingsOuter

% Index format. Miller-Bravais or Miller or Orthogonal? Miller-Bravais as default.
setappdata(gcf,'indexFormat','Miller-Bravais');

% make use of the uibuttongroup GUI object, which manages a few mutual exclusive radio buttons.
h = uibuttongroup(settings,'visible','off', 'units','pix','pos',[10 50 100 80],'tag','indexFormat','title','Index Format','bordert','beveledout','borderw',2);
uicontrol(h,'style','radio', 'string','Miller-Bravais','units','pix','pos',[5 45 85 20],'handlev','off',...
    'tooltip',sprintf('[uvtw], the 4 indexed Miller-Bravais system for hcp.\nAffects input\\output.'));
uicontrol(h,'style','radio', 'string','Miller','units','pix','pos',[5 25 85 20],'handlev','off',...
    'tooltip',sprintf('[uvw], the 3 indexed Miller system.\nAffects input\\output.'));
uicontrol(h,'style','radio', 'string','Orthogonal','units','pix','pos',[5 5 85 20],'handlev','off',...
    'tooltip',sprintf('Displays directions as conventional x,y,z coordinates.\nDisplays planes by their normal vectors.\nAffects output only. Input format is Miller-Bravais.'));
set(h,'selectionChangeFcn',@changeFormat); % this callback execute with a selection change. function is defined at the end of this file.
set(h,'visible','on');
clear h fun_handle

% caRatio input box.
uicontrol(settings,'style','text','string','c/a Ratio','tag','text_caRatio', 'position', [10 25 100 20]);
edit_caRatio();

% checkboxes. These functions create checkboxes and also defines their callbacks.
showAtomsBox();
showMidLayer();

% Projection. Orthographic or Perspective?
h = uibuttongroup(settings,'visible','off', 'units','pix','pos',[120 60 100 70],'tag','projection','title','View Projection','bordert','beveledout','borderw',2);
uicontrol(h,'style','radio', 'string','Orthographic','units','pix','pos',[5 25 85 20],'handlev','off','tooltip',...
    'Maintains the actual size of objects and the angles between objects.');
uicontrol(h,'style','radio', 'string','Perspective','units','pix','pos',[5 5 85 20],'handlev','off','tooltip',...
    sprintf('Objects further from the camera appear smaller.\nDisplays realistic views of real objects.\nDistorts actual angles between objects.'));
    set(h,'selectionChangeFcn',@projectionCallback); % this callback is defined at the end of this file.
set(h,'visible','on');
clear h fun_handle settings


% Save/Load.
saveLoadOuter = uipanel('units','pix','pos',[0 350 140 100],'bordert','none','tag','saveLoadOuter');
saveLoad = uipanel(saveLoadOuter,'units','pix','pos',[10 10 120 90],'title','Save/Load'); clear saveLoadOuter

% save state, as .fig file. save as other format (such as png,pdf... can be done by the 'Savea As' toolbar provided by figure. 
s = sprintf('Saves current state to a .fig file.\nTo save as other format (jpg, pdf, ...),\npress the ''Save Figure'' button in the left top corner of the window.');
uicontrol(saveLoad,'style','push','string','Save State','position',[10 50 100 20],'callback',@saveState,...
'tooltip',s); clear s % saveState() is defined at the end of this file.

% load default. The default is contained in the file 'default.fig' (pre-defined). This works by closing current figure and open the file 'default.fig'.
s = sprintf('Load the default state.\nCurrent information will be lost if unsaved.');
uicontrol(saveLoad,'style','push','string','Default State','position',[10 30 100 20],'callback',@restoreDefaultCallback,'tooltip',s); % function defined at the end of this file.

% load from previously saved .fig file. Works by closing current figure and open the intended file specified by the user.
s = sprintf('Load a previously saved file.\nCurrent information will be lost if unsaved.');
uicontrol(saveLoad,'style','push','string','Load File','position',[10 10 100 20],'callback',@loadFile,'tooltip',s); % function defined at the end of this file.
clear saveLoad

sqrt3 = sqrt(3); % short hand.
% location of atoms, stored in appdata of gcf.
complexHex = [exp(pi*1i*(0:1/3:5/3)) 0]; % use complex numbers to revolve the hexagon.
base = [real(complexHex);imag(complexHex);zeros(1,7)]; % Note that the center of hexagon is also contained here, to facilitate drawing of skeleton lines.
top = [real(complexHex);imag(complexHex);caRatio*ones(1,7)];
complexMid = (1/ sqrt3)*exp(pi*1i*(1/6:2/3:3/2));
mid = [real(complexMid);imag(complexMid);ones(1,3)*.5*caRatio];
atoms = [base mid top];
% hence atoms contains 17 columns, each is a coordinate of a point,
% representing an atom.
% atoms(1:7,:) are base layer atoms, atoms(8:10,:) are mid-layer atoms and atoms(11:17,:) are top layer atoms.

setappdata(gcf,'complexHex',complexHex);
setappdata(gcf,'atoms',atoms);

drawSkeleton(); % draws solid and gray lines for hexagon cylinder, and mid-layer triangle (invisible by default). draws atoms as spheres (invisible by default).

% defines table. 
tableSlipAll(defineSystem('full')); % defineSystem construct cell arrays containing slipSystem objects. tableSlipAll defines the main table and its callback. See the functions for detail.

% table showing direction of intersection planes (invisible by default. appears only when 2 or more planes are being selected.)
tableIntersection();

drawLegend(); % draws legend. function at the end of this file. 

% status text. at the bottom of the window.
status();

end



% Local functions used only in this file.

% Callback for change of selection of the index format.
function [] = changeFormat(~,eventdata)

format = get(eventdata.NewValue,'string');
setappdata(gcf,'indexFormat',format);

% rewrite table.
sys = getappdata(gcf,'systems'); n = length(sys);
tableData = get(findobj('tag','Table Slip All'),'data');

% rewrite load direction.
handleMatrix = getappdata(findobj('tag','left'),'handleMatrix');
handleMatrix = handleMatrix(:,1);
for h = handleMatrix'
    set(h,'string',string(get(h,'userdata'),'simple'));
end


% redefine the table data, using old slipSystem but new format. (New index format is applied, coded within the direction and plane .string functions.)
for i = 1:n
    if isa(sys{i}, 'slipSystem')
        tableData{i,1} = sys{i}.p.string;
        tableData{i,2} = sys{i}.d.string;
    end
end

set(findobj('tag','Table Slip All'),'data',tableData);
delete(findobj('tag','currentSystem'));
figureResize();

% to show xyz axes when indexFormat is orthogonal.
if strcmp(getappdata(gcf,'indexFormat'),'Orthogonal')
    set(findobj('tag','hexAxes'),'visible','off');
    set(findobj('tag','OrthoAxes'),'visible','on');
else
    set(findobj('tag','hexAxes'),'visible','on');
    set(findobj('tag','OrthoAxes'),'visible','off');
end
    
status(['Index format set to ' format '.']);
end



% Callback of projection type selection.
function [] = projectionCallback(~,eventdata)
projectionType = get(eventdata.NewValue,'string');
set(gca,'projection',projectionType);
status(['Projection type set to ' projectionType '.']);
end

% Callback of restore default settings.
function [] = restoreDefaultCallback(varargin)

% dialog box to ask user whether to reset to default.
TF = questdlg('Are you sure to restore the default settings? All current data will be lost if unsaved.'...
    ,'Restore default settings','Yes','No','No');

if strcmp(TF,'Yes')
    close all force hidden; % close current figure.
    clear all;open('default.fig'); deleteToolBars(); % open new figure from file 'default.fig'.
    status('Default Settings Restored.');
end
end

% Callback of load file.
function [] = loadFile(varargin)

% standard way asking user to browse for the file he wants to open.
[filename,pathname] = uigetfile({'*.fig','hcp Loadable Files';'*.*','All Files'});

if filename ~= 0
    filename = [pathname filename];
    TF = questdlg(['Are you sure to load from ' filename '? All current data will be lost if unsaved.']...
        ,'Load From File','Yes','No','No');
    if strcmp(TF,'Yes');
        close('all', 'force', 'hidden');
        clearvars -except filename
        open(filename); deleteToolBars();status(['Loaded from file ' filename '.']);
    end
end
end

% Callback of save state.
function [] = saveState(varargin)
[filename,pathname] = uiputfile({'*.fig','hcp state format'},'Save as','untitled');
if filename ~= 0
    filename = [pathname filename];
    saveas(gcf,filename,'fig');
    status(['Current state saved to ' filename '.']);
end
end

% draw the legend at the left bottom corner. The lines are uicontrol text object containing '<html>&mdash' (code of dash) and with the corresponding color.
function [] = drawLegend() % uses uicontrol radiobutton to enable html. uicontrol text does not support this.
uicontrol('style','radio','ForegroundColor',getappdata(gca,'intersectionColor'),'backgroundcolor','w','fontweight','bold','string','<html>&mdash','fontsize',30,'pos',[-12 20 60 40]);
uicontrol('style','text','backgroundcolor','w','string','Line of Intersection','pos',[50 20 100 20]);
uicontrol('style','radio','ForegroundColor',getappdata(gca,'loadDirectionColor'),'backgroundcolor','w','fontweight','bold','string','<html>&mdash','fontsize',30,'pos',[-12 40 60 40]);
uicontrol('style','text','backgroundcolor','w','string','Load Direction','pos',[50 40 79 20]);
uicontrol('style','radio','ForegroundColor',getappdata(gca,'planeNormalColor'),'backgroundcolor','w','fontweight','bold','string','<html>&mdash','fontsize',30,'pos',[-12 60 60 40]);
uicontrol('style','text','backgroundcolor','w','string','Slip plane Normal','pos',[50 60 90 20]);
uicontrol('style','radio','ForegroundColor',getappdata(gca,'slipDirectionColor'),'backgroundcolor','w','fontweight','bold','string','<html>&mdash','fontsize',30,'pos',[-12 80 60 40]);
uicontrol('style','text','backgroundcolor','w','string','Slip Direction','pos',[50 80 73 20]);
end

function deleteToolBars()
% Delete most toolbar icons, leaving some useful ones.
% delete(findall(gcf,'ToolTipString','Save Figure'));
delete(findall(gcf,'ToolTipString','Open File')); delete(findall(gcf,'ToolTipString','New Figure'));
delete(findall(gcf,'ToolTipString','Link Plot')); delete(findall(gcf,'ToolTipString','Insert Legend')); delete(findall(gcf,'ToolTipString','Edit Plot'));
delete(findall(gcf,'ToolTipString','Show Plot Tools and Dock Figure')); delete(findall(gcf,'ToolTipString','Hide Plot Tools'));
delete(findall(gcf,'ToolTipString','Insert Colorbar')); delete(findall(gcf,'ToolTipString','Brush/Select Data'));
end
