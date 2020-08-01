function [  ] = edit_caRatio( command_str )
% edit_caRatio() initializes the c/a Ratio editable textbox.
% edit_caRatio('value edited') is its callback. The value of current caRation is stored in appdata of figure.
% note, the value of the current caRatio is stored in appdata(gcf,'caRatio').

if nargin == 0
    command_str = 'initialize';
end

switch command_str
    case 'initialize'
        uicontrol(findobj('tag','settings'),'style', 'edit', 'string', '1.633',...
            'units','pix','position', [10 10 100 20], ...
            'tag', 'edit_caRatio','tooltip','After changing c/a ratio, press ''Calculate'' to update the plot and Schmit factors.',...
            'callback', 'edit_caRatio(''value edited'')','backgroundcolor','w','min',0,'max',0);
        setappdata(gcf,'caRatio',1.633);
        
	% callback
    case 'value edited'
        gcbo = findobj('tag','edit_caRatio');
        newValue = str2double(get(gcbo,'string'));
        
        if ~(newValue > 0) % if entry is invalid, return to previously valid value.
            errordlg('Valued entered for c/a ratio is invalid.', 'Invalid c/a ratio');
            set(gcbo,'string',num2str(getappdata(findobj('tag','figure'),'caRatio')));
	    status('Invalid entry for c/a ratio. Value not changed.');
            
        else
            setappdata(gcf,'caRatio',newValue);
            status('c/a ratio updated. Press ''Calculate'' to retrieve new schmit factors.');
        end
end
end
