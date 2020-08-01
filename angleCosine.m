function [ angleCosine ] = angleCosine( u,v )
%angle cosine between two [xyz] vectors.

% if ~isOrthogonalVector(u) && isOrthogonalVector(v)
%     throw(MException('angleCosine:InvalidInput','The inputs must be two vectors of length 3.'));
% end

angleCosine = dot(u,v) / (norm(u,2)*norm(v,2));

end
