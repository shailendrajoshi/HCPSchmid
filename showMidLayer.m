function [  ] = showMidLayer( commandStr )
% showMidLayer() creates the checkbox for showing mid layer structure.
% showMidLayer('value edited') is its callback, which works by turning relavent graph object visible/invisible. 
if nargin == 0; commandStr = 'initialize'; end;

switch commandStr
    case 'initialize'
         uicontrol(findobj('tag','settings'),'style','checkbox','position',[120 30 100 20],'string', ...
            'show mid layer','value', 0, 'tag', 'showMidLayer', ... 
            'callback','showMidLayer(''value edited'')','tooltip','Displays the mid-layer structure.');
        
    case 'value edited'
        TF = get(findobj('tag','showMidLayer'),'value');
        if TF
            set(findobj('tag', 'midLayer'), 'visible', 'on'); status('Mid layer structure is shown.');
        else set(findobj('tag', 'midLayer'), 'visible', 'off'); status('Mid layer structure is hidden.');
        end
end

end
