function [ tableData ] = defineSystem(str)
% tableData = defineSystem('full') redefines all slipSystems fully, calculates Schmit Factors for each system, and generate table data for uitable object. This is only needed when starting the program.
% tableData = defineSystem() only recalculates Schmit Factors and generate appropriate table data. This is invoked when 'Calculate' button is pressed. 


% hard code, defining slip systems shown in the table, in cell array
% format, storing also texts (plane type) in the table.
% Each cell array element reprensents a row in the table; it is either a slipSystem object, or a string to be shown in table.

if nargin == 0
    str = '';
end

numLoad_ = numLoad();
b = 'bypass';

if strcmp(str, 'full')
    % retrieve atom position.
    % atoms = getappdata(gcf,'atoms');
   
    % define planes by atom indices (the index of the column representing each atom) of atoms in appdata(gcf,'atoms').
    baseplane = plane(1:6,[0 0 0 1]);
    s1 = {slipSystem(baseplane,direction(2,-1,-1,0,b))
        slipSystem(baseplane,direction(1,1,-2,0,b))
        slipSystem(baseplane,direction(-1,2,-1,0,b))
        slipSystem(baseplane,direction(-2,1,1,0,b))
        slipSystem(baseplane,direction(-1,-1,2,0,b))
        slipSystem(baseplane,direction(1,-2,1,0,b))};

	% blocks are separated by text in table.
    
    s2 = {slipSystem(plane([1 2 12 11],[1 0 -1 0]),direction(-1,2,-1,0,b))
        slipSystem(plane([1 2 12 11],[1 0 -1 0]),direction(1,-2,1,0,b))
        slipSystem(plane([2 3 13 12],[0 1 -1 0]),direction(2,-1,-1,0,b))
        slipSystem(plane([2 3 13 12],[0 1 -1 0]),direction(-2,1,1,0,b))
        slipSystem(plane([3 4 14 13],[-1 1 0 0]),direction(1,1,-2,0,b))
        slipSystem(plane([3 4 14 13],[-1 1 0 0]),direction(-1,-1,2,0,b))
        slipSystem(plane([4 5 15 14],[-1 0 1 0]),direction(-1,2,-1,0,b))
        slipSystem(plane([4 5 15 14],[-1 0 1 0]),direction(1,-2,1,0,b))
        slipSystem(plane([5 6 16 15],[0 -1 1 0]),direction(2,-1,-1,0,b))
        slipSystem(plane([5 6 16 15],[0 -1 1 0]),direction(-2,1,1,0,b))
        slipSystem(plane([6 1 11 16],[1 -1 0 0]),direction(1,1,-2,0,b))
        slipSystem(plane([6 1 11 16],[1 -1 0 0]),direction(-1,-1,2,0,b))};
    
    s3 = {slipSystem(plane([1 2 17],[1 0 -1 1]),direction(-1,2,-1,0,b))
        slipSystem(plane([1 2 17],[1 0 -1 1]),direction(1,-2,1,0,b))
        slipSystem(plane([2 3 17],[0 1 -1 1]),direction(2,-1,-1,0,b))
        slipSystem(plane([2 3 17],[0 1 -1 1]),direction(-2,1,1,0,b))
        slipSystem(plane([3 4 17],[-1 1 0 1]),direction(1,1,-2,0,b))
        slipSystem(plane([3 4 17],[-1 1 0 1]),direction(-1,-1,2,0,b))
        slipSystem(plane([4 5 17],[-1 0 1 1]),direction(-1,2,-1,0,b))
        slipSystem(plane([4 5 17],[-1 0 1 1]),direction(1,-2,1,0,b))
        slipSystem(plane([5 6 17],[0 -1 1 1]),direction(2,-1,-1,0,b))
        slipSystem(plane([5 6 17],[0 -1 1 1]),direction(-2,1,1,0,b))
        slipSystem(plane([6 1 17],[1 -1 0 1]),direction(1,1,-2,0,b))
        slipSystem(plane([6 1 17],[1 -1 0 1]),direction(-1,-1,2,0,b))};
    
    s4 = {slipSystem(plane([1 2 14 15],[1 0 -1 2]),direction(-1,2,-1,0,b))
        slipSystem(plane([1 2 14 15],[1 0 -1 2]),direction(1,-2,1,0,b))
        slipSystem(plane([2 3 15 16],[0 1 -1 2]),direction(2,-1,-1,0,b))
        slipSystem(plane([2 3 15 16],[0 1 -1 2]),direction(-2,1,1,0,b))
        slipSystem(plane([3 4 16 11],[-1 1 0 2]),direction(1,1,-2,0,b))
        slipSystem(plane([3 4 16 11],[-1 1 0 2]),direction(-1,-1,2,0,b))
        slipSystem(plane([4 5 11 12],[-1 0 1 2]),direction(-1,2,-1,0,b))
        slipSystem(plane([4 5 11 12],[-1 0 1 2]),direction(1,-2,1,0,b))
        slipSystem(plane([5 6 12 13],[0 -1 1 2]),direction(2,-1,-1,0,b))
        slipSystem(plane([5 6 12 13],[0 -1 1 2]),direction(-2,1,1,0,b))
        slipSystem(plane([6 1 13 14],[1 -1 0 2]),direction(1,1,-2,0,b))
        slipSystem(plane([6 1 13 14],[1 -1 0 2]),direction(-1,-1,2,0,b))};
    
    s5 = {slipSystem(plane([1 3 14 16],[1 1 -2 2]),direction(-1,1,0,0,b))
        slipSystem(plane([1 3 14 16],[1 1 -2 2]),direction(1,-1,0,0,b))
        slipSystem(plane([2 4 15 11],[-1 2 -1 2]),direction(-1,0,1,0,b))
        slipSystem(plane([2 4 15 11],[-1 2 -1 2]),direction(1,0,-1,0,b))
        slipSystem(plane([3 5 16 12],[-2 1 1 2]),direction(0,-1,1,0,b))
        slipSystem(plane([3 5 16 12],[-2 1 1 2]),direction(0,1,-1,0,b))
        slipSystem(plane([4 6 11 13],[-1 -1 2 2]),direction(-1,1,0,0,b))
        slipSystem(plane([4 6 11 13],[-1 -1 2 2]),direction(1,-1,0,0,b))
        slipSystem(plane([5 1 12 14],[1 -2 1 2]),direction(-1,0,1,0,b))
        slipSystem(plane([5 1 12 14],[1 -2 1 2]),direction(1,0,-1,0,b))
        slipSystem(plane([6 2 13 15],[2 -1 -1 2]),direction(0,-1,1,0,b))
        slipSystem(plane([6 2 13 15],[2 -1 -1 2]),direction(0,1,-1,0,b))};
    
    s6 = {slipSystem(plane([1 2 12 11],[1 0 -1 0]),direction(-1,2,-1,3,b))
        slipSystem(plane([1 2 12 11],[1 0 -1 0]),direction(1,-2,1,3,b))
        slipSystem(plane([1 2 12 11],[1 0 -1 0]),direction(1,-2,1,-3,b))
        slipSystem(plane([1 2 12 11],[1 0 -1 0]),direction(-1,2,-1,-3,b))
        slipSystem(plane([2 3 13 12],[0 1 -1 0]),direction(-2,1,1,3,b))
        slipSystem(plane([2 3 13 12],[0 1 -1 0]),direction(2,-1,-1,3,b))
        slipSystem(plane([2 3 13 12],[0 1 -1 0]),direction(2,-1,-1,-3,b))
        slipSystem(plane([2 3 13 12],[0 1 -1 0]),direction(-2,1,1,-3,b))
        slipSystem(plane([3 4 14 13],[-1 1 0 0]),direction(-1,-1,2,3,b))
        slipSystem(plane([3 4 14 13],[-1 1 0 0]),direction(1,1,-2,3,b))
        slipSystem(plane([3 4 14 13],[-1 1 0 0]),direction(1,1,-2,-3,b))
        slipSystem(plane([3 4 14 13],[-1 1 0 0]),direction(-1,-1,2,-3,b))
        slipSystem(plane([4 5 15 14],[-1 0 1 0]),direction(-1,2,-1,3,b))
        slipSystem(plane([4 5 15 14],[-1 0 1 0]),direction(1,-2,1,3,b))
        slipSystem(plane([4 5 15 14],[-1 0 1 0]),direction(1,-2,1,-3,b))
        slipSystem(plane([4 5 15 14],[-1 0 1 0]),direction(-1,2,-1,-3,b))
        slipSystem(plane([5 6 16 15],[0 -1 1 0]),direction(-2,1,1,3,b))
        slipSystem(plane([5 6 16 15],[0 -1 1 0]),direction(2,-1,-1,3,b))
        slipSystem(plane([5 6 16 15],[0 -1 1 0]),direction(2,-1,-1,-3,b))
        slipSystem(plane([5 6 16 15],[0 -1 1 0]),direction(-2,1,1,-3,b))
        slipSystem(plane([6 1 11 16],[1 -1 0 0]),direction(-1,-1,2,3,b))
        slipSystem(plane([6 1 11 16],[1 -1 0 0]),direction(1,1,-2,3,b))
        slipSystem(plane([6 1 11 16],[1 -1 0 0]),direction(1,1,-2,-3,b))
        slipSystem(plane([6 1 11 16],[1 -1 0 0]),direction(-1,-1,2,-3,b))};
    
    s7 = {slipSystem(plane([1 2 17],[1 0 -1 1]),direction(-2,1,1,3,b))
        slipSystem(plane([1 2 17],[1 0 -1 1]),direction(-1,-1,2,3,b))
        slipSystem(plane([1 2 17],[1 0 -1 1]),direction(2,-1,-1,-3,b))
        slipSystem(plane([1 2 17],[1 0 -1 1]),direction(1,1,-2,-3,b))
        slipSystem(plane([2 3 17],[0 1 -1 1]),direction(-1,-1,2,3,b))
        slipSystem(plane([2 3 17],[0 1 -1 1]),direction(1,-2,1,3,b))
        slipSystem(plane([2 3 17],[0 1 -1 1]),direction(1,1,-2,-3,b))
        slipSystem(plane([2 3 17],[0 1 -1 1]),direction(-1,2,-1,-3,b))
        slipSystem(plane([3 4 17],[-1 1 0 1]),direction(1,-2,1,3,b))
        slipSystem(plane([3 4 17],[-1 1 0 1]),direction(2,-1,-1,3,b))
        slipSystem(plane([3 4 17],[-1 1 0 1]),direction(-1,2,-1,-3,b))
        slipSystem(plane([3 4 17],[-1 1 0 1]),direction(-2,1,1,-3,b))
        slipSystem(plane([4 5 17],[-1 0 1 1]),direction(2,-1,-1,3,b))
        slipSystem(plane([4 5 17],[-1 0 1 1]),direction(1,1,-2,3,b))
        slipSystem(plane([4 5 17],[-1 0 1 1]),direction(-2,1,1,-3,b))
        slipSystem(plane([4 5 17],[-1 0 1 1]),direction(-1,-1,2,-3,b))
        slipSystem(plane([5 6 17],[0 -1 1 1]),direction(-1,2,-1,3,b))
        slipSystem(plane([5 6 17],[0 -1 1 1]),direction(1,1,-2,3,b))
        slipSystem(plane([5 6 17],[0 -1 1 1]),direction(1,-2,1,-3,b))
        slipSystem(plane([5 6 17],[0 -1 1 1]),direction(-1,-1,2,-3,b))
        slipSystem(plane([6 1 17],[1 -1 0 1]),direction(-1,2,-1,3,b))
        slipSystem(plane([6 1 17],[1 -1 0 1]),direction(-2,1,1,3,b))
        slipSystem(plane([6 1 17],[1 -1 0 1]),direction(1,-2,1,-3,b))
        slipSystem(plane([6 1 17],[1 -1 0 1]),direction(2,-1,-1,-3,b))};
    
    s8 = {slipSystem(plane([1 3 17],[1 1 -2 1]),direction(-2,1,1,3,b))
        slipSystem(plane([1 3 17],[1 1 -2 1]),direction(1,-2,1,3,b))
        slipSystem(plane([1 3 17],[1 1 -2 1]),direction(2,-1,-1,-3,b))
        slipSystem(plane([1 3 17],[1 1 -2 1]),direction(-1,2,-1,-3,b))
        slipSystem(plane([2 4 17],[-1 2 -1 1]),direction(-1,-1,2,3,b))
        slipSystem(plane([2 4 17],[-1 2 -1 1]),direction(2,-1,-1,3,b))
        slipSystem(plane([2 4 17],[-1 2 -1 1]),direction(1,1,-2,-3,b))
        slipSystem(plane([2 4 17],[-1 2 -1 1]),direction(-2,1,1,-3,b))
        slipSystem(plane([3 5 17],[-2 1 1 1]),direction(1,-2,1,3,b))
        slipSystem(plane([3 5 17],[-2 1 1 1]),direction(1,1,-2,3,b))
        slipSystem(plane([3 5 17],[-2 1 1 1]),direction(-1,2,-1,-3,b))
        slipSystem(plane([3 5 17],[-2 1 1 1]),direction(-1,-1,2,-3,b))
        slipSystem(plane([4 6 17],[-1 -1 2 1]),direction(-1,2,-1,3,b))
        slipSystem(plane([4 6 17],[-1 -1 2 1]),direction(2,-1,-1,3,b))
        slipSystem(plane([4 6 17],[-1 -1 2 1]),direction(1,-2,1,-3,b))
        slipSystem(plane([4 6 17],[-1 -1 2 1]),direction(-2,1,1,-3,b))
        slipSystem(plane([5 1 17],[1 -2 1 1]),direction(-2,1,1,3,b))
        slipSystem(plane([5 1 17],[1 -2 1 1]),direction(1,1,-2,3,b))
        slipSystem(plane([5 1 17],[1 -2 1 1]),direction(2,-1,-1,-3,b))
        slipSystem(plane([5 1 17],[1 -2 1 1]),direction(-1,-1,2,-3,b))
        slipSystem(plane([6 2 17],[2 -1 -1 1]),direction(-1,2,-1,3,b))
        slipSystem(plane([6 2 17],[2 -1 -1 1]),direction(-1,-1,2,3,b))
        slipSystem(plane([6 2 17],[2 -1 -1 1]),direction(1,-2,1,-3,b))
        slipSystem(plane([6 2 17],[2 -1 -1 1]),direction(1,1,-2,-3,b))};
    
    s9 = {slipSystem(plane([1 3 14 16],[1 1 -2 2]),direction(-1,-1,2,3,b))
        slipSystem(plane([1 3 14 16],[1 1 -2 2]),direction(1,1,-2,-3,b))
        slipSystem(plane([2 4 15 11],[-1 2 -1 2]),direction(1,-2,1,3,b))
        slipSystem(plane([2 4 15 11],[-1 2 -1 2]),direction(-1,2,-1,-3,b))
        slipSystem(plane([3 5 16 12],[-2 1 1 2]),direction(2,-1,-1,3,b))
        slipSystem(plane([3 5 16 12],[-2 1 1 2]),direction(-2,1,1,-3,b))
        slipSystem(plane([4 6 11 13],[-1 -1 2 2]),direction(1,1,-2,3,b))
        slipSystem(plane([4 6 11 13],[-1 -1 2 2]),direction(-1,-1,2,-3,b))
        slipSystem(plane([5 1 12 14],[1 -2 1 2]),direction(-1,2,-1,3,b))
        slipSystem(plane([5 1 12 14],[1 -2 1 2]),direction(1,-2,1,-3,b))
        slipSystem(plane([6 2 13 15],[2 -1 -1 2]),direction(-2,1,1,3,b))
        slipSystem(plane([6 2 13 15],[2 -1 -1 2]),direction(2,-1,-1,-3,b))};
    
    t1 = {slipSystem(plane([1 2 14 15],[1 0 -1 2]),direction(-1,0,1,1,b))
        slipSystem(plane([2 3 15 16],[0 1 -1 2]),direction(0,-1,1,1,b))
        slipSystem(plane([3 4 16 11],[-1 1 0 2]),direction(1,-1,0,1,b))
        slipSystem(plane([4 5 11 12],[-1 0 1 2]),direction(1,0,-1,1,b))
        slipSystem(plane([5 6 12 13],[0 -1 1 2]),direction(0,1,-1,1,b))
        slipSystem(plane([6 1 13 14],[1 -1 0 2]),direction(-1,1,0,1,b))};
    
    t2 = {slipSystem(plane([1 2 14 15],[1 0 -1 2]),direction(1,0,-1,-1,b))
        slipSystem(plane([2 3 15 16],[0 1 -1 2]),direction(0,1,-1,-1,b))
        slipSystem(plane([3 4 16 11],[-1 1 0 2]),direction(-1,1,0,-1,b))
        slipSystem(plane([4 5 11 12],[-1 0 1 2]),direction(-1,0,1,-1,b))
        slipSystem(plane([5 6 12 13],[0 -1 1 2]),direction(0,-1,1,-1,b))
        slipSystem(plane([6 1 13 14],[1 -1 0 2]),direction(1,-1,0,-1,b))};
    
    t3 = {slipSystem(plane([1 2 17],[1 0 -1 1]),direction(-1,0,1,2,b))
        slipSystem(plane([2 3 17],[0 1 -1 1]),direction(0,-1,1,2,b))
        slipSystem(plane([3 4 17],[-1 1 0 1]),direction(1,-1,0,2,b))
        slipSystem(plane([4 5 17],[-1 0 1 1]),direction(1,0,-1,2,b))
        slipSystem(plane([5 6 17],[0 -1 1 1]),direction(0,1,-1,2,b))
        slipSystem(plane([6 1 17],[1 -1 0 1]),direction(-1,1,0,2,b))};
    
    t4 = {slipSystem(plane([1 3 17],[1 1 -2 1]),direction(-1,-1,2,6,b))
        slipSystem(plane([2 4 17],[-1 2 -1 1]),direction(1,-2,1,6,b))
        slipSystem(plane([3 5 17],[-2 1 1 1]),direction(2,-1,-1,6,b))
        slipSystem(plane([4 6 17],[-1 -1 2 1]),direction(1,1,-2,6,b))
        slipSystem(plane([5 1 17],[1 -2 1 1]),direction(-1,2,-1,6,b))
        slipSystem(plane([6 2 17],[2 -1 -1 1]),direction(-2,1,1,6,b))};
    
    t5 = {slipSystem(plane([1 3 14 16],[1 1 -2 2]),direction(1,1,-2,-3,b))
        slipSystem(plane([2 4 15 11],[-1 2 -1 2]),direction(-1,2,-1,-3,b))
        slipSystem(plane([3 5 16 12],[-2 1 1 2]),direction(-2,1,1,-3,b))
        slipSystem(plane([4 6 11 13],[-1 -1 2 2]),direction(-1,-1,2,-3,b))
        slipSystem(plane([5 1 12 14],[1 -2 1 2]),direction(1,-2,1,-3,b))
        slipSystem(plane([6 2 13 15],[2 -1 -1 2]),direction(2,-1,-1,-3,b))};
    
    t6 = {slipSystem(plane([1 3 15],[1 1 -2 3]),direction(-1,-1,2,2,b))
        slipSystem(plane([2 4 16],[-1 2 -1 3]),direction(1,-2,1,2,b))
        slipSystem(plane([3 5 11],[-2 1 1 3]),direction(2,-1,-1,2,b))
        slipSystem(plane([4 6 12],[-1 -1 2 3]),direction(1,1,-2,2,b))
        slipSystem(plane([5 1 13],[1 -2 1 3]),direction(-1,2,-1,2,b))
        slipSystem(plane([6 2 14],[2 -1 -1 3]),direction(-2,1,1,2,b))};
        
    t7 = {slipSystem(plane([1 3 10],[1 1 -2 4]),direction(-2,-2,4,3,b))
        slipSystem(plane([2 4 10],[-1 2 -1 4]),direction(2,-4,2,3,b))
        slipSystem(plane([3 5 8],[-2 1 1 4]),direction(4,-2,-2,3,b))
        slipSystem(plane([4 6 8],[-1 -1 2 4]),direction(2,2,-4,3,b))
        slipSystem(plane([5 1 9],[1 -2 1 4]),direction(-2,4,-2,3,b))
        slipSystem(plane([6 2 9],[2 -1 -1 4]),direction(-4,2,2,3,b))};
    
    % insert text(plane type to be shown in the table) to form entire data. Stored as 'systems' in
    % figure appdata. '|' means an empty row in the table.
    sys = ['Basal Plane'; s1; '|'; 'Prismatic Planes'; s2; '|'; ...
        'Pyramidal Planes 1st type, 1st order'; s3; '|'; 'Pyramidal Planes 1st type, 2nd order'; s4; '|'; ...
        'Pyramidal Planes 2nd type, 2nd order'; s5; '|'; 'Slip out of a (a+c)'; 'Prismatic Planes'; s6; '|'; ...
        'Pyramidal Planes 1st type, 1st order'; s7; '|'; 'Pyramidal Plane 2nd type, 1st order'; s8; '|'; ...
        'Pyramidal Planes 2nd type, 2nd order'; s9; '|'; 'Twinning'; 'Group 1'; t1; '|'; 'Group 2'; t2; '|';...
        'Group 3'; t3; '|'; 'Group 4'; t4; '|'; 'Group 5'; t5; '|'; 'Group 6'; t6; '|'; 'Group 7'; t7];
    clear s1 s2 s3 s4 s5 s6 s7 s8 s9 atoms base top baseplane
    setappdata(gcf,'systems',sys);
    
    % defines uitable data (cell array). Derive entries for each cell of table, from sys.
    n = length(sys);
    tableData = cell(n,2+numLoad_);
    prefix = '<HTML><font size="4">'; % gui accepts html. 
    
    for i = 1:n
        if isa(sys{i}, 'slipSystem')
            tableData{i,1} = sys{i}.p.string;
            tableData{i,2} = sys{i}.d.string;
            schmitFactors = schmit(sys{i}); % calculate schmit factors for each slip system. If there is more than one load directions, schmit function outputs a vector containing schmit factors of all loads.
            for j = 1:numLoad_
                tableData{i,2+j} = schmitFactors(j);
            end
        elseif sys{i} == '|'
            tableData{i,1} = ''; tableData{i,2} = ''; tableData{i,3} = '';
        else
            s = sys{i}; m = length(s);
            assert(isa(sys{i},'char'));
            
	    % distribute texts in a row..
            if m>= 20
                tableData{i,1} = [prefix s(1:10)];
                tableData{i,2} = [prefix s(11:20)];
                tableData{i,3} = [prefix s(21:m)];
            elseif m>= 10
                tableData{i,1} = [prefix s(1:10)];
                tableData{i,2} = [prefix s(11:m)];
                if s(11) == 'e'; tableData{i,1} = [tableData{i,1} 'e']; tableData{i,2}=[prefix 'plane'];
                elseif s(11) == 'f'; tableData{i,1} = [tableData{i,1} 'f']; tableData{i,2} = [prefix 'a (a+c)']; end;
            else
                tableData{i,1} = [prefix s(1:m)];
            end
        end
    end
    
else   % only recalculates schmit factors. call this when loads are edited/added/removed, and/or c/a ratio is changed.
    h_table = findobj('tag','Table Slip All');
    tableData = get(h_table,'data');
    sys = getappdata(gcf,'systems'); n = length(sys);
    numLoad_ = numLoad();
    
    for i = 1:n
        if isa(sys{i}, 'slipSystem')
            schmitFactors = schmit(sys{i});
            for j = 1:numLoad_
                tableData{i,2+j} = schmitFactors(j);
            end
        end
    end
    
    
    % if c/a ratio is changed, and format is orthogonal, the planes and
    % diretions must be recalculated.
    if strcmp(getappdata(gcf,'indexFormat'),'Orthogonal')
        for i = 1:n
            if isa(sys{i}, 'slipSystem')
                tableData{i,1} = sys{i}.p.string;
                tableData{i,2} = sys{i}.d.string;
            end
            
            % rewrite load direction.
            handleMatrix = getappdata(findobj('tag','left'),'handleMatrix');
            handleMatrix = handleMatrix(:,1);
            for h = handleMatrix'
                set(h,'string',string(get(h,'userdata'),'simple'));
            end
        end
    end

    % below configures tablewidth and column width of table.
set(findobj('tag','Table Slip All'),'data',tableData);
    set(h_table,'data',tableData);
    
    columnName = {'Slip plane' 'Slip Direction' 'Schmit Factor'};
    columnFormat = {'char' 'char' 'char'};
    columnWidth = {'auto','auto',110};
    
    if numLoad_ > 1
        for i = 1:numLoad
            columnName{i+2} = ['<html>Schmit Factor<br>#' num2str(i)];
            columnFormat{i+2} = 'char';
            columnWidth{i+2} = 90;
        end
    end
    
    
    set(h_table,'columnName',columnName,'columnFormat',columnFormat,'columnWidth',columnWidth);
    figureResize();
    
end
end