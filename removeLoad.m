function [ h ] = removeLoad( str )
%removeLoad() creates the cross button, with callback being removeLoad('callback').

if nargin == 0
    str = 'initialize';
end

panelLoad = findobj('tag','left');

switch str
    case 'initialize'
        h = uicontrol(panelLoad,'style','push','string','x','position',[133 80 20 20],'visible','off','callback','removeLoad(''callback'')',...
            'tooltip',sprintf('Remove this load direction.\nThe table will not be updated until the ''Calculate'' button is pressed.'));
        
    case 'callback'
        handleMatrix = getappdata(panelLoad,'handleMatrix');
        S = size(handleMatrix);
        
        % find which of the loads are intending to be deleted.
        for i = 1:S(1)
            if handleMatrix(i,3) == gcbo
                delete(handleMatrix(i,:));
                handleMatrix(i,:) = [];
                break;
            end
        end
        
        S = size(handleMatrix);
        nrows = S(1);
        setappdata(panelLoad,'handleMatrix',handleMatrix);
        
        % set new positions.
        for i = 1:nrows
            set(handleMatrix(i,1),'posi',[35 100+S(1)*10-20*i 90 20],'visible','on','selected','off');
            set(handleMatrix(i,2),'posi',[10 97+S(1)*10-20*i 20 20],'visible','on','string',['#' num2str(i)]);
            set(handleMatrix(i,3),'posi',[133 100+S(1)*10-20*i 20 20],'visible','on');
        end
        set(findobj('tag','Add Load'),'posi',[35 80+S(1)*10-20*i 60 15],'visible','on');
        
        % if there is only one load left, deactivate the remove load button.
        if nrows == 1
            set(handleMatrix(1,[2 3]),'visible','off');
        end
        
        setappdata(panelLoad,'NumofLoad',nrows);
        status('Load removed.');
    otherwise
end


end