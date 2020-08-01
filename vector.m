classdef vector < direction
    %vector is a direction with a relative magnitude c, noted by c[uvtw].
    %provide nonnegativity check for magnitude, modifies length and
    %orthogonal conversion methods of the superclass.
    
    properties (Access = protected)
        magnitude = 0;
    end
    
    properties (Dependent, SetAccess = private, Hidden)
        validC
    end
    
    methods
        function TF = get.validC( obj )
            TF = (isnumeric(obj.magnitude) && (obj.magnitude >= 0) && isscalar(obj.magnitude));
        end
    end
    
    methods
        % vector(d, c) returns a vector of direction d and magnitude c.
        % vector(d) leaves c as default of 1.
        % vector(u,v,t,w,c) returns a vector of index c[uvtw].
        % vector(u,v,t,w) returns 1[uvtw].
        
        % vector(...,'bypass') bypasses all validation checks.
        function obj = vector(varargin)
            n = nargin; bypass = '';
            if n > 1 && ischar(varargin{n})
                bypass = varargin{n}; n = n-1;
            end
            
            u = 0; v = 0; t = 0; w = 0; c = 0;
            if n == 2 && isa(varargin{1}, 'direction') && isnumeric(varargin{2})
                if varargin{2} < 0
                    varargin{1} = -varargin{1};
                    varargin{2} = -varargin{2};
                end
                c = varargin{2};
                u = varargin{1}.u; v = varargin{1}.v; t = varargin{1}.t; w = varargin{1}.w;
            elseif n == 5
                u = varargin{1}; v = varargin{2}; t = varargin{3}; w = varargin{4}; c = varargin{5};
                if c < 0
                    u = -u; v = -v; t = -t; w = -w; c = -c;
                end
            elseif n == 1 && isa(varargin{1}, 'vector')
                u = varargin{1}.u; v = varargin{1}.v; t = varargin{1}.t; w = varargin{1}.w;
                c = varargin{1}.magnitude;
            elseif n == 1 && isa(varargin{1}, 'direction')
                u = varargin{1}.u; v = varargin{1}.v; t = varargin{1}.t; w = varargin{1}.w;
                c = 1;
            elseif n == 4
                u = varargin{1}; v = varargin{2}; t = varargin{3}; w = varargin{4}; c = 1;
            end
            
            obj = obj@direction(u,v,t,w);
            obj.magnitude = c;
            if ~strcmp(bypass,'bypass')
                if ~obj.validC
                    throw(MException('vector:InvalidMagnitude', 'Magnitude of a vector must be a nonnegative scalar.'));
                end
            end
        end
        
        
        % length of vector.
        function out = length(obj)
            if ~obj.validC
                throw(MException('vector:abs:InvalidMagnitude', 'Magnitude of a vector must be a nonnegative scalar.'));
            end
            out = obj.magnitude * length@direction(obj);
        end
        
        % [x,y,z] = v' or u = v' returns the coordinates of v in orthorgonal basis.
        function [x,y,z] = ctranspose(obj)
            if ~obj.validC
                throw(MException('vector:ctranspose:InvalidMagnitude', 'Magnitude of a vector must be a nonnegative scalar.'));
            end
            [x,y,z] = ctranspose@direction(obj);
            x = obj.magnitude*x; y = obj.magnitude*y; z = obj.magnitude*z;
            if nargin == 1
                x = [x y z];
            end
        end     
    end
end