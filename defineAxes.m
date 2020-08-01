function [  ] = defineAxes( command_str )
%defineAxes() draws hcp axes in fresh figure.
%defineAxes('redraw') performs a clear of all graphs before initialization,
%with current (new) caRatio value.

if nargin == 0
    command_str = 'initialize';
end

if strcmp(command_str,'redraw') % delete all children of axes object.
    delete(get(gca,'children')); caRatio_ = caRatio;
    axesFormat = 'Miller-Bravais';
else
    caRatio_ = 1.633; axesFormat = getappdata(gcf,'indexFormat');
end

% script to draw axis of hcp.
S = getappdata(gca,'axisSize');
axisColor = getappdata(gca,'axisColor');

axis(S*[-1 1.2 -1 1 0 caRatio_]); view(-5,30); axis equal;
set(gca,'box', 'off',...
    'xlimmode', 'm', 'ylimmode', 'm', 'zlimmode', 'm', 'nextplot', 'add', ...
    'xtick', [], 'ytick', [], 'ztick', [], 'visible', 'off');
sqrt3 = sqrt(3);

% axis of hcp. See the function arrowLine(start,final).
% there are 2 sets of axes, a1 a2 a3 z, and xyz. xyz to be shown when index
% format is orthogonal. The 2 sets are tagged with 'hexAxes' and 'OrthoAxes' respectively.
arrowLine([0 0 0],S*[1 0 0],'color',axisColor);
[h1, h2] = arrowLine([0 0 0],S*[-.5 .5*sqrt3 0],'color',axisColor);
[h3, h4] = arrowLine([0 0 0],S*[-.5 -.5*sqrt3 0],'color',axisColor); set([h1 h2 h3 h4],'tag','hexAxes','visible','off');
arrowLine([0 0 0],S*[0 0 caRatio_],'color',axisColor);
[h1, h2] = arrowLine([0 0 0],S*[0 1 0],'color',axisColor); set([h1 h2],'tag','OrthoAxes','visible','off');

% axis labels.
h1 = text(1.1*S,0,0,'a_1'); h2 = text(1.1*-.5*S,1.1*.5*sqrt3*S,0,'a_2');
h3 = text(1.2*-.5*S, 1.2*-.5*sqrt3*S, 0, 'a_3'); h4 = text(0,0,1.1*caRatio_*S, 'z');
set([h1 h2 h3],'tag','hexAxes','visible','off');
hx = text(1.1*S,0,0,'x','tag','OrthoAxes','visible','off');
hy = text(0,1.1*S,0,'y','tag','OrthoAxes','visible','off');
set([h1 h2 h3 h4 hx hy], 'interpreter', 'tex', 'fontsize', 10, 'color', axisColor);

% choose which set of axes to display.
if strcmp(axesFormat,'Orthogonal')
    set(findobj('tag','OrthoAxes'),'visible','on');
else set(findobj('tag','hexAxes'),'visible','on');
end

rotate3d;
end
