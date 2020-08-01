function [ out ] = caRatio(  )
%recieves c/a ratio from current figure appdata.
out = getappdata(gcf,'caRatio');

end