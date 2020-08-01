function [] = figureResize(varargin)
% Callback for resize of figure. Resizes and moves individual parts in the window.

i = get(gcf,'posi'); h = i(4); w = i(3);
p = @positive; N = numLoad();

% conditioning on number of load, to decide table width
if N > 1
    tableWidth = 175 + 90*numLoad();
else tableWidth = 285;
end


% conditioning on Index Format, to decide column width and table width of table.
if strcmp(getappdata(gcf,'indexFormat'),'Orthogonal')
    tableWidth = tableWidth + 126;
    columnWidth = {150,150,90};
    if N > 1
        for i = 2:N
            columnWidth = [columnWidth,{90}]; %#ok<AGROW>
        end
    end
elseif N > 1
    columnWidth = {'auto','auto',90};
    for i = 2:N
        columnWidth = [columnWidth {90}]; %#ok<AGROW>
    end
else columnWidth = {'auto','auto',110};
end


% set 'position' for parts.
set(findobj('tag','Table Slip All'),'posi',[p(w-tableWidth),0,tableWidth,h],'columnwidth',columnWidth);
set(findobj('tag','shade'), 'pos', [0 p(h-190) 10000 190]);
set(findobj('tag','saveLoadOuter'),'posi',[0 p(h-290) 140 100]);
set(findobj('tag','Table Slip All'),'posi',[p(w-tableWidth),0,tableWidth,h]);
set(findobj('tag','status'),'posi',[130 0 p(w-140-tableWidth) 20]);
set(findobj('tag','tableIntersection'),'posi',[p(w-245-tableWidth),5,245,155]);
set(findobj('tag','tableTitle'),'posi',[p(w-245-tableWidth),150,245,30]);
set(gca,'posi',[0 40 p(w-10-tableWidth) p(h-210)]);
status('Window resized.');
end


% program gives error when setting width/height to non-positive numbers.
% keeps positive numbers, turns non-positive numbers to 1.
function x = positive(x)
if x <= 0
    x = 1;
end
end
