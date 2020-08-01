classdef direction < miller
    %direction is a subclass of miller.
    %   Provides a length method. Constructor allows conversion
    %   from orthorgonal coordinates. Provides methods for conversion to
    %   orthogonal coordinates, computation of angle / angleCosine between
    %   two directions.
    
    
    methods
        % direction(u,v,t,w) returns direction [uvtw].
        % direction(v) with v being a vector of length 4 returns [v1v2v3v4].
        % direction(x,y,z) returns the direction of xi + yj + zk.
        % direction(v) where v = [x y z] returns direction(x,y,z).
        % direction(s) intakes the numerical interpretation of string s.
        
        % direction(...,'bypass') bypasses all validation checks. see
        % superclass constructor.
        function obj = direction(varargin)
            n = nargin; bypass = '';
            if n > 1 && ischar(varargin{n})
                bypass = varargin{n};
                n = n-1;
            end
                
            if (n == 1 && ischar(varargin{1}))
                varargin{1} = str2num(varargin{1}); %#ok<ST2NM>
                if ~(length(varargin{1}) == 4 || length(varargin{1}) == 3)
                    throw(MException('direction:InvalidStringEntry', 'Invalid string for miller index.'))
                end
                
                if strcmp(getappdata(gcf,'indexFormat'),'Miller')
                    x = varargin{1};
                    if length(x) ~= 3
                        throw(MException('direction:InvalidStringEntry', 'Index format mismatch. Please check the Index Format setting.'))
                    end
                    d = directionUVW(x(1),x(2),x(3)); d = d';
                    varargin{1} = [d.u d.v d.t d.w];
                    clear x d
                else
%                     if length(varargin{1}) ~= 4
%                         throw(MException('direction:InvalidStringEntry', 'Index format mismatch. Please check the Index Format setting.'))
%                     end
                end
            end
            
            % below is conversion from xyz to miller system (if the input
            % is in corresponding format). result is reflected on varargin directly.
            if n; i = varargin{1}; end;
            flag = 0;
            if (n == 1 && isvector(i) && length(i) == 3)
                j = i(2); k = i(3); i = i(1);
                flag = 1;
            elseif n == 3
                j = varargin{2}; k = varargin{3};
                flag = 1;
            end
            
            if flag
                if ~(isOrthogonalVector([i j k]) )
                    throw(MException('direction:direction:InputxyzCoorNotValid', 'Input xyz coordinates must be scalar numerics.'));
                end
                
                i = 2*i/3;
                j = .5*(1.15470053838*j - i);
                
                l = k / caRatio;
                k = -i-j;
                [i,j,k,l] = rat4(i,j,k,l);

                varargin = {i j k l bypass};
            end
            % conversion to (uvtw) complete.
            
            
            obj = obj@miller(varargin{:});
            
        end
    end
    
    methods
        % length of a vector
        function out = length( obj )
            out = sqrt(3*(obj.u*obj.u + obj.u*obj.v + obj.v*obj.v) + (caRatio * obj.w)^2);
        end
        
        % reverse the direction.
        function reversed = uminus(obj)
            reversed = direction(-obj.u, -obj.v, -obj.t, -obj.w);
        end
        
        % directionA  .^  directionB returns the angleCosine between the
        % two.
        function angleCosine = power(obj, obj2)
            if ~(obj.initialized && obj2.initialized)
                throw(MException('direction:power_angleCosine:directionNotInitialized', 'One of the directions are not initialized.'));
            end
            ca_ = (caRatio^2) / 3;
            top = obj.u * obj2.u + obj.v * obj2.v + (obj.u * obj2.v + obj2.u * obj.v )/2 + obj.w * obj2.w * ca_;
            bottom1 = obj.u * obj.u + obj.v * obj.v + obj.u * obj.v + obj.w * obj.w * ca_;
            bottom2 = obj2.u * obj2.u + obj2.v * obj2.v + obj2.u * obj2.v + obj2.w * obj2.w * ca_;
            angleCosine = top / sqrt(bottom1 * bottom2);
            if abs(angleCosine) > 1
                throw(MException('direction:power_angleCosine:CalculatedCosineOutofValidRange', 'Error, calculated angle cosine out of [-1,1] range.'));
            end
        end
        
        % directionA ^ directionB returns the angle (in radians) between
        % the two. (angle in absolute value; sign is not considered.)
        function angle = mpower(obj, obj2)
            angle = acos(power(obj, obj2));
        end
        
        % [x,y,z] = d' or v = d' converts direction d to orthonormal
        % coordinate system, with a1 overlyingwith x-axis, z overlying with
        % z-axis. magnitude of a is taken to be unity.
        function [x,y,z] = ctranspose(obj)
            x = 1.5*obj.u; y = .86602540378444*(2*obj.v + obj.u);
            z = obj.w * caRatio;
            if nargout == 1
                x = [x y z];
            end
        end
        
        % string function is same as superclass, except for adding '[]'.
        function s = string( obj,simple )
            if ~strcmp(getappdata(gcf,'indexFormat'),'Orthogonal')
                if nargin == 1
                s = ['<HTML>[' string@miller(obj) ']'];
                else s = string@miller(obj,simple);
                end
                
                elseif nargin == 1
                    s = ['<HTML>' string@miller(obj)];
            else s = string@miller(obj,simple);
            end
        end
             
    end
end

% utility function for constructor.
% normalizes the indices to integers, with a small tolerance since the
% floating point representation is never accurate. Tested to be working,
% but complexity to be improved..

function [i,j,k,l] = rat4(x,y,z,w)
v = rat_(x,y,z,w);
i = v(1);j = v(2);k = v(3); l = v(4);
end