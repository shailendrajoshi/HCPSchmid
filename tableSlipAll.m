function [  ] = tableSlipAll( source,eventdata)
%tableSlipAll(tableData) creates the table using tableData to define the
%cells. tableSlipAll(source,eventdata) is invoked as the
%cellSelectionCallback of the table, that is, it is executed everytime when a table cell
%is selected or deselected. automatically passed in two arguments, source
%is the handle of the table object, eventdata contains the latest indices
%of all cells that are selected.

%the cellSelectionCallback plots the slip system (systems) that are being
%selected on the axes. If more than one systems are selected (Ctrl+mouse to
%multi-select), the table of intersection is shown, displaying pairs of
%planes and calculated direction of their intersection, plotting the
%intersection line on graph which is allowed to be checked on/off. The
%maximum number allowed for selected systems are 4.

if nargin == 1
    uitable('units','pix','position',[739 0 285 640], 'rowname',[],'columnname',{'Slip plane' 'Slip Direction' 'Schmit Factor'},'columnwidth',{'auto','auto',110},...
        'fontsize',13,'fontname','Lucida Sans Regular','tag','Table Slip All','data',source,'CellSelectionCallback',@tableSlipAll,'columnformat',{'char','char','char'},...
        'tooltip',sprintf('Click to a select system for sketching.\nMultiple selections will also calculate and draw the intersecting directions of planes.\nCtrl+Click to multiselect.'));
    
else
    tableOn = @() set([findobj('tag','tableIntersection') findobj('tag','tableTitle')],'visible','on');
    tableOff = @() set([findobj('tag','tableIntersection') findobj('tag','tableTitle')],'visible','off');
    
    Indices = eventdata.Indices(:,1);
    Indices = unique(Indices); % remove double counting of selected cells of the same row.
    num_selected = length(Indices); % number of rows selected. Some may be texts.
    sys = getappdata(gcf,'systems');
    
    j = 1; text = [];
    for i = 1:num_selected
        if ~isa(sys{Indices(i)},'slipSystem') % remove indices that refer to texts.
            text(j) = i; j = j+1; %#ok<AGROW>
        end
    end
    
    Indices(text) = []; % now these are systems selected.
    num_selected = length(Indices);
    
    switch num_selected
        case 0
            tableOff(); % turn off the table of intersection.
            deleteAllIntersection();
            % status('Systems deselected.');
        case 1 % delete previous plotted system and draw the current one.
            deleteAllIntersection();
            s = sys{Indices};
            delete(findobj('tag','currentSystem'));
            plot(s);
            str1 = s.p.string; str1 = str1(7:length(str1));
            str2 = s.d.string; str2 = str2(7:length(str2));
            status(['<HTML>Plotted system: slip plane ' str1 ' slip direction ' str2 '.']);
            tableOff(); % turn off the table of intersection.
        otherwise
            if num_selected > 5
                errordlg('Too many selections','Error'); return;
            else
                delete(findobj('tag','currentSystem'));
                for i = 1:num_selected % plots all systems that are selected.
                    s = sys{Indices(i)};
                    plot(s);
                end
                C = getappdata(gca,'intersectionColor' );
                deleteAllIntersection(); % deletes all intersection lines that have been drawn previously.
                switch num_selected
                    case 2
                        l = sys{Indices(1)}.p | sys{Indices(2)}.p;
                        if isempty(l)
                            set(findobj('tag','tableIntersection'),'data',{sys{Indices(1)}.p.string,sys{Indices(2)}.p.string,'parallel',false} );
                        else
                            set(findobj('tag','tableIntersection'),'data',{sys{Indices(1)}.p.string,sys{Indices(2)}.p.string,l.string,true} );
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection1');
                        end
                    case 3 % hard code...calculates and draws intersection, defines tabledata for intersection table.
                        data = cell(3,4);
                        l = sys{Indices(1)}.p | sys{Indices(2)}.p; % calculates line of intersection. see plane.or
                        if isempty(l)
                            data(1,:) = {sys{Indices(1)}.p.string,sys{Indices(2)}.p.string,'parallel',false};
                        else
                            data(1,:) = {sys{Indices(1)}.p.string,sys{Indices(2)}.p.string,l.string,true};
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection1');
                        end
                        
                        l = sys{Indices(1)}.p | sys{Indices(3)}.p;
                        if isempty(l)
                            data(2,:) = {sys{Indices(1)}.p.string,sys{Indices(3)}.p.string,'parallel',false};
                        else
                            data(2,:) = {sys{Indices(1)}.p.string,sys{Indices(3)}.p.string,l.string,true};
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection2');
                        end
                        
                        l = sys{Indices(2)}.p | sys{Indices(3)}.p;
                        if isempty(l)
                            data(3,:) = {sys{Indices(2)}.p.string,sys{Indices(3)}.p.string,'parallel',false};
                        else
                            data(3,:) = {sys{Indices(2)}.p.string,sys{Indices(3)}.p.string,l.string,true};
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection3');
                        end
                        
                        set(findobj('tag','tableIntersection'),'data',data);
                    case 4
                        data = cell(6,4);
                        
                        l = sys{Indices(1)}.p | sys{Indices(2)}.p;
                        if isempty(l)
                            data(1,:) = {sys{Indices(1)}.p.string,sys{Indices(2)}.p.string,'parallel',false};
                        else
                            data(1,:) = {sys{Indices(1)}.p.string,sys{Indices(2)}.p.string,l.string,true};
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection1');
                        end
                        
                        l = sys{Indices(1)}.p | sys{Indices(3)}.p;
                        if isempty(l)
                            data(2,:) = {sys{Indices(1)}.p.string,sys{Indices(3)}.p.string,'parallel',false};
                        else
                            data(2,:) = {sys{Indices(1)}.p.string,sys{Indices(3)}.p.string,l.string,true};
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection2');
                        end
                        
                        l = sys{Indices(2)}.p | sys{Indices(3)}.p;
                        if isempty(l)
                            data(3,:) = {sys{Indices(2)}.p.string,sys{Indices(3)}.p.string,'parallel',false};
                        else
                            data(3,:) = {sys{Indices(2)}.p.string,sys{Indices(3)}.p.string,l.string,true};
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection3');
                        end
                        
                        l = sys{Indices(1)}.p | sys{Indices(4)}.p;
                        if isempty(l)
                            data(4,:) = {sys{Indices(1)}.p.string,sys{Indices(4)}.p.string,'parallel',false};
                        else
                            data(4,:) = {sys{Indices(1)}.p.string,sys{Indices(4)}.p.string,l.string,true};
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection4');
                        end
                        
                        l = sys{Indices(2)}.p | sys{Indices(4)}.p;
                        if isempty(l)
                            data(5,:) = {sys{Indices(2)}.p.string,sys{Indices(4)}.p.string,'parallel',false};
                        else
                            data(5,:) = {sys{Indices(2)}.p.string,sys{Indices(4)}.p.string,l.string,true};
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection5');
                        end
                        
                        l = sys{Indices(3)}.p | sys{Indices(4)}.p;
                        if isempty(l)
                            data(6,:) = {sys{Indices(3)}.p.string,sys{Indices(4)}.p.string,'parallel',false};
                        else
                            data(6,:) = {sys{Indices(3)}.p.string,sys{Indices(4)}.p.string,l.string,true};
                            draw(l,'arrow','off','color',C,'linewidth',3,'tag','intersection6');
                        end
                        
                        set(findobj('tag','tableIntersection'),'data',data);
                    otherwise
                end
                tableOn(); % shows the table of intersection.
                status('Selected systems plotted. plane intersections plotted. Directions of plane intersections shown.');
            end
    end
end
end

% deletes all intersection lines that have been drawn previously.
function out = deleteAllIntersection()
delete(findobj('tag','intersection1'));delete(findobj('tag','intersection2'));
delete(findobj('tag','intersection3'));delete(findobj('tag','intersection4'));
delete(findobj('tag','intersection5')); delete(findobj('tag','intersection6'));delete(findobj('tag','intersection7')); out = [];
end