classdef slipSystem
    %slipSystem utilizes plane (slip plane) and direction (slip direction)
    %to represent a slip system.
    % provides calculation of schmit factor for the system. provides
    % function to draw the system.
    
    
    properties
        p = plane();
        d = direction();
    end
    
    methods
        % slip(plane,direction), simple constructor method. Checks if
        % direction is on the plane.
        
        function obj = slipSystem(p,d)
            if nargin ~= 2
                p = plane(); d = direction();
            end
            obj.p = p; obj.d = d;
            
            % checks if direction is on plane. throw error if not.
            if abs(dot([obj.p.u obj.p.v obj.p.t obj.p.w], [obj.d.u obj.d.v obj.d.t obj.d.w])) >= 1e-3
                throw(MException('slipSystem:incompatibleDirectionplane', ...
                    'The slip direction does not lie on the slip plane.'));
            end
        end
        
        
        % draws slip plane,slip direction,slip load. arrows starts at the
        % center of the plane. slip load is not drawn if there are multiple
        % loads. (to avoid the mess) All the graph objects are tagged with
        % 'currentSystem', to fercilitate deletion of drawing. (
        % delete(findobj('tag','currentSystem')) deletes all graph drawn in
        % this function.
        function plot( obj )
            directionColor = getappdata(gca,'slipDirectionColor');
            handleMatrix = getappdata(findobj('tag','left'),'handleMatrix');
            loadD = get(handleMatrix(:,1),'userdata');
            n = size(loadD); n = n(1);
            
            if isa(obj.p,'plane')
                [hPatch,hLine,hArrow] = plotNormal(obj.p);
                [hDirection,hDirectionArrow] = arrowLine(obj.p.center', obj.p.center' + obj.d' / length(obj.d), 'color',directionColor);
                
                if n == 1 % draws load direction only if there is one load.
                    [h5,h6] = arrowLine(obj.p.center', obj.p.center' + loadD'/length(loadD), 'color',getappdata(gca,'loadDirectionColor'));
                    set([h5 h6 hPatch hLine hArrow hDirection,hDirectionArrow], 'tag','currentSystem');
                else set([hPatch hLine hArrow hDirection,hDirectionArrow], 'tag','currentSystem');
                end
            else
%                 RADIUS = .5;
%                 assert(isa(obj.p, 'simplePlane'));
%                 normal = obj.p.normal; center = [0 0 0]';
%                 
%                 if abs(normal(3)) < 1e-6
%                     p1 = [0 0 1]';
%                 else
%                     p1 = [0 1 (- normal(2) / normal(3))]';
%                     p1 = p1/norm(p1,2);
%                 end
%                 
%                 crossmatrix = [0 -normal(3) normal(2); normal(3) 0 -normal(1); -normal(2) normal(1) 0];
%                 tensor = kron(normal',normal);
%                 
%                 R = @(t) eye(3)*cos(t) + sin(t)*crossmatrix + (1-cos(t)) * tensor;
%                 
%                 p2 = R(2*pi/3) * p1;
%                 p3 = R(-2*pi/3) * p1;
%                 p1 = p1*RADIUS; p2 = p2 * RADIUS; p3 = p3*RADIUS;
%                 
%                 patch([p1(1) p2(1) p3(1)],[p1(2) p2(2) p3(2)],[p1(3) p2(3) p3(3)],[.6 .6 .6],'tag','currentSystem','facealpha',getappdata(gca,'planeTransparency'));
%                 [h1, h2]= arrowLine(center, center+normal);
%                 [h3, h4]= arrowLine(center', center' + obj.d' / norm(obj.d',2), 'color',directionColor);
%                 if n == 1
%                     [h5, h6]= arrowLine(center', center' + loadD'/length(loadD), 'color',getappdata(gca,'loadDirectionColor'));
%                     set([h1 h2 h3 h4 h5 h6],'tag','currentSystem');
%                 else
%                     set([h1 h2 h3 h4],'tag','currentSystem');
%                 end
                
            end
        end
        
        function TF = eq(obj,obj2)
            TF = (obj.p == obj2.p && obj.d == obj2.d);
        end
        
%         function out = permute( obj )
%             if isa(obj,'plane')
%                 throw(MException('slipSystem:permute:invalidInput','Only a simple plane can be permuted.'));
%             end
%             
%             u = obj.p.u; v = obj.p.v; t = obj.p.t; w = obj.p.w;
%             i = obj.d.u; j = obj.d.v; k = obj.d.t; l = obj.d.w;
%             temp = [obj slipSystem(simplePlane(-u,-v,-t,w),direction(-i,-j,-k,l)) ...
%                 slipSystem(simplePlane(u,t,v,w),direction(i,k,j,l)) slipSystem(simplePlane(-u,-t,-v,w),direction(-i,-k,-j,l)) ...
%                 slipSystem(simplePlane(v,u,t,w),direction(j,i,k,l)) slipSystem(simplePlane(-v,-u,-t,w),direction(-j,-i,-k,l)) ...
%                 slipSystem(simplePlane(v,t,u,w),direction(j,k,i,l)) slipSystem(simplePlane(-v,-t,-u,w),direction(-j,-k,-i,l)) ...
%                 slipSystem(simplePlane(t,u,v,w),direction(k,i,j,l)) slipSystem(simplePlane(-t,-u,-v,w),direction(-k,-i,-j,l)) ...
%                 slipSystem(simplePlane(t,v,u,w),direction(k,j,i,l)) slipSystem(simplePlane(-t,-v,-u,w),direction(-k,-j,-i,l))];
%             temp = simpleUnique(temp);
%             
%             n = length(temp);
%             out(2*n) = slipSystem(temp(n).p,-temp(n).d);
%             for i = 1:n
%                 out(2*i-1) = slipSystem(temp(i).p,temp(i).d);
%                 out(2*i) = slipSystem(temp(i).p,-temp(i).d);
%             end
%         end
        

% calculation of schmit factor.
        function out = schmit(obj)
            handleMatrix = getappdata(findobj('tag','left'),'handleMatrix');
            loadDirections = get(handleMatrix(:,1),'userdata');
            n = size(loadDirections); n = n(1);
            
            out = zeros(1,n);
            if n == 1
                out = (loadDirections.^(obj.d)) * ((loadDirections')*obj.p.normal / length(loadDirections));
                if abs(out) < 1e-6
                    out = 0;
                end
            else % for multiple loads, a vector of schmit factors is returned, in an ordered sequence.
                for i = 1:n
                    D = loadDirections{i};
                    out(i) = (D.^(obj.d)) * ((D')*obj.p.normal / length(D));
                    if abs(out(i)) < 1e-6
                        out(i) = 0;
                    end
                end
            end
        end
    end
end