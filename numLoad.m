function [ out ] = numLoad( )
%numLoad() returns number of loads currently stored.
out = getappdata(findobj('tag','left'),'NumofLoad');

end