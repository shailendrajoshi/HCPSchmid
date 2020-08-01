function [ handle ] = connect( start,final, varargin )
% handle = connect(point1,point2) connects point1 and point2 by drawing
% line) connecting the correspoinding columns of point1 and point2.
% can either be in 2D (arguments of 2 columns) or 3D (arguments of 3 columns).
% in all cases the first 2 arguments must have the same size.

% one can pass additional arguments defining line color, line style ect. example:
% connect(point1, point2, 'color','r','linestyle','-.','linewidth',2);

n = size(start);
if ~isequal(n,size(final))
    throw(MException('connect:dimensionInequality', 'The dimensions must be identical.'));
end

if isvector(start) % base case, with only one point (one column) contained in start and final.
    switch length(start)
        case 2
            handle = line([start(1) final(1)],[start(2) final(2)],varargin{:});
        case 3
            handle = line([start(1) final(1)],[start(2) final(2)],[start(3) final(3)], varargin{:});
        otherwise
            throw(MException('connect:dimensionIncorrect', 'The dimensions of point coordinates are incorrect.'));
    end
else
    hold on; handle = zeros(n(2),1); % recursively draw lines for each column.
    for i = 1:n(2)
        handle(i) = connect(start(:,i), final(:,i), varargin{:});
    end
end       

end
