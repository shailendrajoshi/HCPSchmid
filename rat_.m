function [v] = rat_(varargin)
% normalize a few numbers by a common factor to integers. Not working for
% some c/a ratios. To be improved.


% remove zeros, and insert back to output.
for index = 1:nargin
    if abs(varargin{index}) < 1e-3
        % temp = varargin;
        varargin(index) = [];
        v = rat_(varargin{:});
        v = [v(1:index-1) 0 v(index:nargin-1)];
        return;
    end
end

% remove signs, and put it back to output.
array = cell2mat(varargin);
s = sign(array);

if or_(s == -1)
    x = num2cell(abs(array));
    v = s.*rat_(x{:});
    return;
end

if nargin == 1 && varargin{1} ~= 0
    v = 1;
    return;
end

% actual operations.
for index = 1:length(array)
    array(index) = nearest(1000*array(index))/1000;
end
[top, bottom] = rat(array);
r = lcm_(bottom);
v = array*r;
r = gcd_(top);
v = v/r;

end


% lcm of more than 2 inputs.
function out = lcm_(array)
n = length(array);
if n == 1
    out = array(1);
elseif n == 2
    out = lcm(array(1), array(2));
else
    out = lcm_([array(1:n-2) lcm(array(n-1),array(n))]);
end
end


% gcd of more than 2 inputs.
function out = gcd_(array)
n = length(array);
if n == 1
    out = array(1);
elseif n == 2
    out = gcd(array(1), array(2));
else
    out = gcd_([array(1:n-2) gcd(array(n-1),array(n))]);
end
end


% long or
function TF = or_(varargin)
n = nargin;
if n == 0
    TF = false; return;
elseif n == 1
    if varargin{1}
        TF = true;
    else TF = false;
        return;
    end
elseif n == 2
    TF = or(varargin{:});
elseif varargin{n}
    TF = true;
else TF = or_(varargin{1:nargin - 1});
end
end