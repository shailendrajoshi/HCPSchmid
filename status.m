function [  ] = status( str )
% status() initializes the status text box showing 'Program initialized.'.
% status(str) prints str in the status box.

if nargin == 0
    uicontrol('style','toggle','units','pix','pos',[130 0 599 20],'str','Program initialized.','tag','status',...
    'horizontala','cen','backgroundcolor','w','enable','inactive','fontname','Lucida Sans Regular');
else
set(findobj('tag','status'),'string', str);
end
end
