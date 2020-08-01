function [ h ] = edit_LoadDirection( command_str )
%h = edit_LoadDirection() initializes a editable textbox for load direction
%input. Note that it is set to invisible as default.
% edit_LoadDirection('value edited') is the callback executed when
%the value is edited by the user. It checks the validity of the user input
%and store it as the new load direction.
% note, the load direction object is stored as the userdata of the textbox.

if nargin == 0
    command_str = 'initialize';
end

switch command_str
    case 'initialize'
        if strcmp(getappdata(gcf,'indexFormat'),'Miller')
            s = '-1 -1 0';
        else
            s = '-1 -1 2 0';
        end
        h = uicontrol(findobj('tag','left'),'style', 'edit', 'units','pix','position', [35 80 90 20], 'visible','off',...
            'backgroundcolor','w','string','-1 -1 2 0', 'userdata',direction(s),'callback','edit_LoadDirection(''value edited'')');
        
    case 'value edited'
        h1 = gcbo;
        errflag = 0;
        try newD = direction(get(h1,'string'));
        catch error % catches error of invalid user input and throw an error dialog box.
            oldD = get(h1,'userdata');
            set(h1,'string',num2str([oldD.u oldD.v oldD.t oldD.w])); % return to the last valid data.
            errordlg(error.message, error.identifier); errflag = 1;
	    status('Invalid entry for load direction. Value not changed.');
        end
        
        if ~errflag
            set(h1,'userdata',newD);
            status('Load Direction updated. Press ''Calculate'' to retrieve new schmit factors.');
        end
end
