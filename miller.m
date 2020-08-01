classdef miller
    %miller is a general miller-Bravis index for hexagonal system. It
    %stores 4 indices. direction and plane are its subclasses. miller defines shared features of them.
    
    % Dependent properties provides boolean validation checks.
    % Setters performs validation checks of inputs before setting.

    % Constructor accepts various forms of inputs.
    % Also provides string output, absstract method uminus.
    
    properties (GetAccess = public,SetAccess = protected)
        u = 0; % if left unset, the indices are zeros.
        v = 0;
        t = 0;
        w = 0;
    end
    
    properties (Dependent,SetAccess = private, Hidden)
        initialized % boolean of whether indices are initialized (the 4 indices are not all 0).
        add2zero % boolean of whether the first three indices add up to 0.
    end

    
    methods        
        function TF = get.initialized( obj )
            TF = ( obj.u ||  obj.v ||  obj.t ||  obj.w);
        end
        
        function TF = get.add2zero( obj )
            TF = ( obj.u +  obj.v +  obj.t == 0);
        end                      
    end
    
    methods
        % miller(u,v,t,w) returns miller index [uvtw].
        % miller(v) with v being a vector of length 4 returns [v1v2v3v4].
        
        % miller(...,'bypass') bypasses all validity checks. (integer index, first three indices add to zero, and is lowest form.) Reduces
        % starting time. Constructions with non user-input does not need validity check.
        
        function obj = miller(varargin)
            n = nargin; bypass = 0;
            if n > 1 && ischar(varargin{n}) % if the last input is 'bypass',then bypass is set to true
                bypass = strcmp(varargin{n},'bypass');
            end

            if ~bypass
                setter = @indexSet; % if bypass is false, the input goes through validation checks provided by indexSet function. Error produced if invalide.
                switch n
                    case 4
                        obj.u = setter(varargin{1});
                        obj.v = setter(varargin{2});
                        obj.t = setter(varargin{3});
                        obj.w = setter(varargin{4});
                    case 1
                        i = varargin{1};
                        if (length(i) == 4 && isvector(i))
                            obj.u = setter(i(1)); obj.v = setter(i(2)); obj.t = setter(i(3)); obj.w = setter(i(4));
                        end
                    otherwise
                end
               
                if ~obj.add2zero % checks if first 3 indices add to zero.
                    throw(MException('miller:miller:first3indicesAddtoNoneZero', 'The first three indices must add to 0.'));
                end
                
                % reduce to lowest index by the common ratio.
                r = gcd(gcd(gcd(obj.u,obj.v),obj.t),obj.w);
                if (r ~= 1 && r~= 0)
                    obj.u = obj.u / r; obj.v = obj.v / r; obj.t = obj.t / r; obj.w = obj.w / r;
                end
            else % set the indices without any checks.
                switch n
                    case 5
                        obj.u = varargin{1}; obj.v = varargin{2}; obj.t = varargin{3}; obj.w = varargin{4};
                    case 2
                        i = varargin{1};
                        if (length(i) == 4 && isvector(i))
                            obj.u = i(1); obj.v = i(2); obj.t = i(3); obj.w = i(4);
                        end
                    otherwise
                end
            end
             
        end
        
        % string(obj) output a string which will prints the index (with overbar instead
        % of negative sign, using undocumented Matlab feature of html
        % interpreting of uicontrols texts). Different index formats are
        % taken into account, and conversion to format from Miller-Bravais
        % is done inside function.
        
        % string(obj,'simple') prints index directly, with negative sign
        % instead of overbar.
        function s = string(obj,~)
            if strcmp(getappdata(gcf,'indexFormat'),'Miller')
                if isa(obj,'direction')
                    i1 = obj.u-obj.t; i2 = obj.v-obj.t; i3 = obj.w;
                    if gcd(i1,gcd(i2,i3)) ~= 1
                        i1 = i1/3; i2 = i2/3; i3 = i3/3;
                    end
                    if nargin == 1
                        s = [num2str_(i1) num2str_(i2) num2str_(i3)];
                    else s = num2str([i1 i2 i3]);
                    end
                else
                    if nargin == 1
                        s = [num2str_(obj.u) num2str_(obj.v) num2str_(obj.w)];
                    else s = num2str([obj.u obj.v obj.w]);
                    end
                end
            elseif strcmp(getappdata(gcf,'indexFormat'),'Orthogonal')
                [x,y,z] = Orthogonal(obj);
                x = roundx(x,-3); y = roundx(y,-3); z = roundx(z,-3);
                
                s = [num2str(x) ', ' num2str(y) ', ' num2str(z)];
                if nargin == 1
                    s = ['<font size=''3''>' s];
                end
            else % Miller-Bravais
                if nargin == 1
                    s = [num2str_( obj.u) num2str_( obj.v) num2str_( obj.t) num2str_( obj.w)];
                else s = num2str([obj.u obj.v obj.t obj.w]);
                end
            end
        end
    end
    
    methods (Abstract)
        % reverse the direction, orientation.
        uminus(obj);
    end
    
    methods
        % euqality. All indices are the same.
        function TF = eq(obj, obj2)
            TF = (obj.u == obj2.u && obj.v == obj2.v && obj.t == obj2.t && obj.w == obj2.w);
        end  
    end
    
end

% local utility functions

function out = roundx( in,n )
f = 10^(-n);
out = in*f;
out = nearest(out)/f;
end

% num2str with negative sign replaced by overbar notion. For
% method miller.string.
function s = num2str_(n)
if n >= 0
    s = num2str(n);
else
    s = num2str(-n);
    s = [s '&#773<>'];
end

if n >= 10
    s = [' ' s ' ']; % add space if not single digit.
end
end

% isint_(in) returns true if in is a integer. Allows for a
% small tolerance of 1e-6. Utility of validate.
function TF = isint_( in )
TF = (abs(nearest(in) - in) < 1e-6);
end

% checks whether the input is a valid index (scalar integer). Exceptions
% are genereted when the input is invalid.
function [] = validindex( in )
if ~isnumeric( in )
    throwAsCaller(MException('miller:validindex:InputNotNumeric', 'Index must be numeric.'));
end

if ~isscalar( in )
    throwAsCaller(MException('miller:validindex:InputNotScalar', 'Index must be scalar.'));
end

if ~isint_( in )
    throwAsCaller(MException('miller:validindex:InputNotInteger', 'Index must be integer.'));
end
end

% validity check, then set to nearest integer.
function out = indexSet( in )
validindex(in);
out = nearest(in);
end
