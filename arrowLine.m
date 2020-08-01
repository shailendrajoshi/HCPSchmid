function [ hLine, hArrow ] = arrowLine( point1,point2,varargin )
% arrowLine( point1, point2) draws a line between them, and add an arrow (a surf object of a cone shape), of the same color, at the end of point2 side.
% arrowLine(point1,point2,'headheight',xx,'headwidth',yy) alters the default size of the arrowhead drawn.
% the function returns two handles separately. One can pass additional arguments to specify the line property. example:
% arrowLine( point1, point2, 'color','r','linewidth',3,'headheight',0.2);

% default size of the arrowhead.
headheight = 0.1;
headwidth = 0.05;

flag = [0 0];

% checks if the arrowhead size is altered by the user.
if ~isempty( varargin )
    for c = 1:floor(length(varargin)/2)
        if strcmpi(varargin{c*2-1}, 'headheight')
            headheight =  varargin{c*2}; flag(1) = c;
        elseif strcmpi(varargin{c*2-1},'headwidth')
            headwidth = varargin{c*2}; flag(2) = c;
        end
    end
end
if flag(1) % remove the 'headheight','headwidth' arguments from varargin{:}, so that varargin{:} can be passed to line object.
    varargin([2*flag(1)-1,2*flag(1)]) = [];
end
if flag(2)
    varargin([2*flag(2)-1,2*flag(2)]) = [];
end


% hold on;  % removed since it takes significant time. in the hcp program, it is always in hold on state.

hLine = connect(point1,point2,varargin{:}); % use the connect() function to draw the line.

% defines a cone of correct size, but located at origin and directed upwards.
[x,y,z] = cylinder([.5*headwidth 0],10);
z = headheight*z;

% draw the arrow cone with correct size and location, but wrong orientation.
hArrow = surf(x+point2(1),y+point2(2),z+point2(3),'edgecolor','none','facecolor',get(hLine,'color'),'visible','off');

% below rotates the cone to correct orientation.
direction = point2 - point1; 
axisRotation = - cross(direction, [0 0 1]);

if abs(axisRotation(1)) > .001 || abs(axisRotation(2)) > .001 || abs(axisRotation(3)) > .001
    
    rotationAngle =   (180/pi)*acos( dot(direction,[0 0 1]) / (norm(direction,2) ) );
    rotate(hArrow, axisRotation, rotationAngle, point2); % rotate the cone to the correct orienation.
end

set(hArrow,'visible','on');

end
