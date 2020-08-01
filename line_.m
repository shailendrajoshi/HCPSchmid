classdef line_ < vector
    %line is a line segment in space. Defined by a vector and a starting
    %point. The length of the line is defined by the superclass vector.
    %provides drawing function.
    
    properties (Access = protected)
        start = [0 0 0];
    end
    
    properties (Dependent, SetAccess = private)
        final % final = start + length (defined in superclass vector)
    end
    
    methods
        function out = get.final(obj)
            out = obj.start + obj';
        end
    end
    
    methods
        % l = line_(v) constructs line with vector v and start at origin.
        % l = line_(v,s) constructs line with vector v and start s.
        % l = line_(u,v) constructs line with start u and final v.
        % l = line_(u,v,t,w,c,s) constructs line with direction [uvtw],
        % magnitude c, start s.
        % l = line_(u,v,t,w,c) takes s as origin.
        % l = line_(u,v,t,w) takes s as origin and c as 1.
        
        function obj = line_(varargin)
            n = nargin; bypass = '';
            if n > 1 && ischar(varargin{n})
                bypass = varargin{n}; n = n-1;
            end
            
            switch n
                case 1
                    if isa(varargin{1},'vector')
                        v = varargin{1}; s = [0 0 0];
                    else v = vector(); s = [0 0 0];
                    end
                case 2
                    if isa(varargin{1},'vector') && isOrthogonalVector(varargin{2})
                        v = varargin{1}; s = varargin{2};
                    elseif isOrthogonalVector(varargin{1}) && isOrthogonalVector(varargin{2})
                        d = varargin{2} - varargin{1};
                        v = vector(direction(d), norm(d,2)/length(direction(d)));
                        s = varargin{1};
                    else v = vector(); s = [0 0 0];
                    end
                case 4
                    s = [0 0 0]; v = vector(direction(varargin{1},varargin{2},varargin{3},varargin{4}),1);
                case 5
                    v = vector(direction(varargin{1},varargin{2},varargin{3},varargin{4}),varargin{5});
                    s = [0 0 0];
                case 6
                    v = vector(direction(varargin{1},varargin{2},varargin{3},varargin{4}),varargin{5});
                    s = varargin{6};
                otherwise
                    v = vector(); s = [0 0 0];
            end

            obj = obj@vector(v,bypass);
            obj.start = s;
        end
        
        
        % draw the line. draw(obj,'arrow','off') does not draw arrowhead.
        % draw(obj,'propertyname1','propertyvalue1',...) passes the
        % properies to arrowLine or connect function,depending whether
        % 'arrow' is set to 'off'.
        function h_line = draw(obj,varargin)
            arrow = 1;
            if ~isempty( varargin )
                for c = 1:floor(length(varargin)/2)
                    if strcmpi(varargin{c*2-1}, 'arrow')
                        if strcmpi(varargin{c*2}, 'off')
                            arrow = 0; end;
                        varargin([2*c-1,2*c]) = [];
                        break;
                    end
                end
            end
            
            if arrow
                h_line = arrowLine(obj.start, obj.final,varargin{:});
            else h_line = connect(obj.start, obj.final,varargin{:});
            end
        end
        
        
    end
end