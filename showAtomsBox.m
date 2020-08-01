function [  ] = showAtomsBox( commandStr )
% showAtomsBox() creates the checkbox to show atoms.
% showAtomsBox('value edited') is its callback, which works by turning the relavent graph object visible/invisible.

if nargin == 0; commandStr = 'initialize'; end;

switch commandStr
    case 'initialize'
        uicontrol(findobj('tag','settings'),'style','checkbox','position',[120 10 100 20],'string', ...
            'show atoms','value', 0, 'tag', 'showAtomsBox', ... 
            'callback','showAtomsBox(''value edited'')','tooltip','Shows all atoms in the unit cell as spheres.');
        
    case 'value edited'
        TF = get(findobj('tag','showAtomsBox'),'value');
        if TF
            set(findobj('tag', 'atoms'), 'visible', 'on'); status('Atoms are shown.');
        else set(findobj('tag', 'atoms'), 'visible', 'off'); status('Atoms are hidden.');
        end
end

end
