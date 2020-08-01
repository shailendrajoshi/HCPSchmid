function [ TF ] = isOrthogonalVector( in )
%this returns true only when input is a row/column vector with 3
%numeric elements.

TF = isvector(in) && (length(in) == 3) && isnumeric(in);

end