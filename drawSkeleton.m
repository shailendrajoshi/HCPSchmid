function [  ] = drawSkeleton(  )

% draws solid and gray lines for hexagon cylinder, and mid-layer triangle (invisible by default). draws atoms as spheres (invisible by default).


% retrieve information from appdata.
atoms = getappdata(gcf,'atoms');
base = atoms(:,1:7); mid = atoms(:,8:10); top = atoms(:,11:17);
axisColor = getappdata(gca,'axisColor');
atomSize = getappdata(gcf,'atomSize');
atomColorA = getappdata(gcf,'atomColorA');
atomColorB = getappdata(gcf,'atomColorB');

% black solid skeleton. See the function connect(start,final).
connect([base(:,1:6) top(:,1:6)], [base(:,[2 3 4 5 6 1]) top(:,[2 3 4 5 6 1]) ], 'color','k');
connect(base,top,'color','k');

% axis lines on top base plane, same as color of axis.
connect(top(:,[1 3 5]),[zeros(2,3);caRatio*ones(1,3)],'color',axisColor);

% draw (invisible) spheres for each atom.
layerA = [base top]; layerB = mid;

% layer A atoms.
[x,y,z] = sphere(10); x = atomSize*x; y = atomSize*y; z = atomSize*z;
for index = 1:14
    x1 = x+layerA(1,index); y1 = y+layerA(2,index); z1 = z+layerA(3,index);
    surf(x1,y1,z1,'facecolor',atomColorA, 'edgecolor','none','facealpha',.4, ...
        'tag','atoms','visible','off');
end
% layer B atoms.
for index = 1:3
        x1 = x+layerB(1,index); y1 = y+layerB(2,index); z1 = z+layerB(3,index);
    surf(x1,y1,z1,'facecolor',atomColorB, 'edgecolor','none','facealpha',.4, ...
        'tag','atoms','visible','off');
end

% mid layer structure. Default is invisible.
connect(mid, mid(:,[2 3 1]),'color','k','visible', 'off','tag','midLayer');
end
