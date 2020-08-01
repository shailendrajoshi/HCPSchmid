function [ ] = tableIntersection( ~,eventdata )
%tableIntersection() initializes the intersection table, defaulted to be
%invisible. only turned visible when more than one slip system is selected
%(see tableSlipAll).
%tableIntersection(source,eventdata) is its CellEditCallback. performs showing/hiding of the particular
%intersection line when a check box in table is edited.

if nargin == 0
    uicontrol(findobj('tag','shade'),'style','text','string','plane Intersections','tag','tableTitle','units','pix','pos',[494 150 245 30],'horizontala','cent','visible','off');
    uitable(findobj('tag','shade'),'data',[],'posi',[494 5 245 155],'tag','tableIntersection','visible','off', 'fontname','Lucida Sans Regular','fontsize',12,...
    'columnname',{'plane 1' 'plane 2' 'intersection' 'show'},'columnformat',{'char','char','char','logical'},'columnedit',[false false false true], ...
    'CellEditCallback', @tableIntersection,'columnwidth',{60,60,80,40},'rowname',[]);
else
i = eventdata.Indices(1); % row number that is being edited.
TF = eventdata.NewData; % checkbox on/off state.

if TF % turn the intersection visible/invisible based on checkbox state.
    set(findobj('tag',['intersection' num2str(i)]),'visible','on');
    status(['intersection ' num2str(i) ' shown']);
else
    set(findobj('tag',['intersection' num2str(i)]),'visible','off');
    status(['intersection ' num2str(i) ' hidden']);
end

end
end