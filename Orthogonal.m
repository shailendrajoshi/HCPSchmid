function [ x,y,z ] = Orthogonal( input )
if isa(input,'direction')
    x = input';
    y = x(2);z = x(3);x = x(1);
elseif isa(input,'plane')
    x = input.normal;
    y = x(2);z = x(3);x = x(1);
else
end


end