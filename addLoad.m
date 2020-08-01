function [ ] = addLoad( str )
%addLoad() creates the Add Load button, with callback being addLoad('callback').

if nargin == 0
    str = 'initialize';
end

panelLoad = findobj('tag','left');
switch str
    case 'initialize'
        panelLoad = findobj('tag','left');
        uicontrol(panelLoad,'style','push','tag','Add Load','string','Add Load','position',[35 60 60 15],'horizontala','left',...
            'callback','addLoad(''callback'')','tooltip',sprintf('Add more load directions.\nThe Schmit factor of each direction will be displayed separately in the table.'));
    case 'callback'
        % this callback make use of handleMatrix to retrieve current state
        % and add another load editable textbox below. Then the
        % handleMatrix is modified to new state.
        
        handleMatrix = getappdata(panelLoad,'handleMatrix');
        S = size(handleMatrix);
        nrows = S(1)+1;
        
        % creates new objects.
        handleMatrix(nrows,1) = edit_LoadDirection();
        handleMatrix(nrows,2) = uicontrol(panelLoad,'style','text','string',['#' num2str(nrows)],'visible','off');
        handleMatrix(nrows,3) = removeLoad();
        setappdata(panelLoad,'handleMatrix',handleMatrix);
        
        % set appropriate positions.
        for i = 1:nrows
            set(handleMatrix(i,1),'posi',[35 100+S(1)*10-20*i 90 20],'visible','on'); set(handleMatrix(i,2),'posi',[10 97+S(1)*10-20*i 20 20],'visible','on'); set(handleMatrix(i,3),'posi',[133 100+S(1)*10-20*i 20 20],'visible','on');
        end
        set(gcbo,'posi',[35 80+S(1)*10-20*i 60 15]);
        
        % if maximum number of loads have been reached, deactivate the 'Add Load button
        if nrows == getappdata(panelLoad,'maxLoad');
            set(gcbo,'visible','off');
        end
        
        setappdata(panelLoad,'NumofLoad',nrows);
        status('Load added. Please edit the newly added load direction.');
                    
    otherwise
end


end