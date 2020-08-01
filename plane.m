classdef plane < miller
    %plane is a subclass of miller. It defines a plane in space, with fixed
    %vertices (triangle or quadrilaterial). validvertices provides a check
    %on the format validity. center is the centroid of the polygon. normal
    %direction is defined by (can be recovered from) the conversion from
    %[uvtw] notation to [xyz]. center and normal are dependent properties.
    
    % position of vertices is stored as indices of atoms matrix
    % (getappdata(gcf,'atoms') see mainApp location of atoms. Storing
    % indices instead of actual coordinates makes it unnecessary to
    % re-calculate plane properties after changing of c/a ratio.
    
    %constructor takes in vertices matrix and the orientation determining
    %the direction of normal. orientation is defaulted to 1. Flip of normal
    %direction of plane p can be done by -p. Also provides plot functions.
    
    
    %Note that in order to produce the patch correctly, the atomIndex must
    %be in correct order to form a polygon (in an order of
    %consecutive vertices of polygon.)
    
    properties (Dependent, SetAccess = private)
        validVertices % to check whether all vertices are on the same plane.
        normal % normalized to unit vector.
        vertices % column vector, coordinates of vertices. retrieved from property atoms.
        center % center of polygon.
    end
    
    properties (Access = protected)
        atoms = [0 0 0]; % this is column index of getappdata(gcf,'atoms'), refering to 3 or 4 or 6 atoms. See mainApp location of atoms.
    end
    
    methods
        function TF = get.validVertices(obj)
            TF = isvector(obj.atoms); if ~TF; return; end;
            n = length(obj.atoms);
            
            TF = (max(obj.atoms) <= 17 && min(obj.atoms)>=0); if ~TF; return; end;
            TF = ((n==3||n==4||n==6) && isnumeric(obj.atoms)); if ~TF; return; end;
            
            % checks if all vertices are on the same plane.
            if n==4
                TF = abs(dot(obj.vertices(:,1),obj.normal)-dot(obj.vertices(:,4),obj.normal)) < 1e-6 && TF;
            elseif n==6
                TF = abs(dot(obj.vertices(:,1),obj.normal)-dot(obj.vertices(:,4),obj.normal)) < 1e-6 ...
                    && abs(dot(obj.vertices(:,1),obj.normal)-dot(obj.vertices(:,5),obj.normal)) < 1e-6 ...
                    && abs(dot(obj.vertices(:,1),obj.normal)-dot(obj.vertices(:,6),obj.normal)) < 1e-6;
            end
        end
        
        
        % derive normal from index and caRatio. 
        function out = get.normal(obj)
            out = [obj.u; (obj.v*2 + obj.u)*0.57735026919; (obj.w) ./ caRatio];
            out = out/ norm(out,2);
        end
        
        % retrieve vertices coordinates, from atom indexing and caRatio.
        function out = get.vertices(obj)
            out = getappdata(gcf,'atoms');
            out = out(:,obj.atoms);
        end
        
        % center of polygon.
        function out = get.center( obj )
            out = mean(obj.vertices,2);
        end
    end
    
    methods
        % obj = plane(atomIndex) or obj = plane(vertices, 1) returns a plane
        % with given atomIndex, with normal oriented away the origin.
        % obj = plane(atomIndex, -1) returns a plane with normal pointed to
        % the origins.
        % obj = plane(atomIndex,uvtwIndex) bypasses the calculation from
        % vertices to [uvtw] index, to enhance performance and avoid
        % possible error in rat_. This also bypasses all other relavent
        % validity checks, in the superclass.
        
        function obj = plane(atomIndex,argument2)
            nullplane = false; % nullplane = true when no argument is passed.
            bypass = false;
            switch nargin
                case 1
                    argument2 = 1;
                case 2
                    if isscalar(argument2)
                        argument2 = sign(argument2);
                    else assert(length(argument2) == 4)
                        bypass = true;
                        u = argument2(1); v = argument2(2);
                        t = argument2(3); w = argument2(4);
                    end
                        
                otherwise
                    atomIndex = zeros(1,3); argument2 = 1; nullplane = true;
            end
            
            % compute index from vertices, if not intended to bypass. Error in rat_ with some c/a ratios.
            if ~(bypass || nullplane)
                a = getappdata(gcf,'atoms');
                n = cross(a(:,atomIndex(1))-a(:,atomIndex(2)), a(:,atomIndex(2))-a(:,atomIndex(3)));
                
                if argument2 == 1
                    if dot(n,a(:,atomIndex(1))) < 0
                        n = -n;
                    end
                else
                    if dot(n,a(:,atomIndex(1))) > 0
                        n = -n;
                    end
                end
                
                u = n(1);
                v = .5*(1.732050807568877*n(2) - u);
                t = -u-v;
                w = caRatio*n(3);
                [u,v,t,w] = rat4(u,v,t,w);
            elseif nullplane
                u = 0; v = 0; t = 0; w = 0;
            end
            
            if bypass
                bypass = 'bypass';
            else bypass = '';
            end
            
            obj = obj@miller(u,v,t,w,bypass);
            obj.atoms = atomIndex;

%             if ~obj.validVertices
%                 throw(MException('plane:plane:InvalidVertices','plane Vertices are invalid.'));
%             end            
        end
        
        % draw the plane as a patch on a figure.
        function h = plot(obj )
            v = obj.vertices;
            h = patch(v(1,:),v(2,:),v(3,:),getappdata(gca,'planeColor'),'facealpha',.5,'edgecolor','none');
        end
        
        % draw the plane together with its normal vector (with arrow).
        % plotNormal(obj,color,propertyname1,propertyvalue1,...) properties
        % are passed to arrowLine function drawing the normal.
        function [hPatch, hLine, hArrow] = plotNormal(obj)                 
            hPatch = plot(obj ); c = obj.center;
            [hLine, hArrow] = arrowLine(c,c + obj.normal,'color',getappdata(gca,'planeNormalColor'));
        end                

        
        % flip the direction of the normal. Just flipping the indices will do.
        function obj = uminus(obj)
            obj.u = -obj.u; obj.v = -obj.v;
            obj.t = -obj.t; obj.w = -obj.w;
        end
        
        % returns [xyz] coordintates of its normal.
        function [x,y,z] = ctranspose(obj)
            x = obj.normal;
            if nargout == 3
                y = x(2); z = x(3); x = x(1);
            end
        end
        
        % Add '()' upon baseclass string function.
        function s = string( obj )
            if ~strcmp(getappdata(gcf,'indexFormat'),'Orthogonal')
                s = ['<HTML>(' string@miller(obj) ')'];
            else s = ['<HTML>' string@miller(obj)];
            end
        end
        
        % p1 | p2 computes line intersection of the 2 planes. Returns the 
        % empty matrices if 2 planes are parallel. Otherwise output a line_
        % object.
        
        % The line starts at its intercept with x-y plane, goes in positive z direction,
        
        % If the line of intersection is parralel to x-y plane, use x-z plane
        % instead.
        
        function out = or(obj, obj2)
            if (obj == obj2)||(obj == -obj2) % if parallel.
                out = []; return;
            end
            
            % the zone law. [UVW] is direction of the intersection.
            U = obj.v * obj2.w - obj2.v * obj.w;
            V = obj.w * obj2.u - obj2.w * obj.u;
            W = obj.u * obj2.v - obj2.u * obj.v;
            
            % converts [UVW] to [uvtw] representation.
            out = (directionUVW(U,V,W))';
            if out.w < 0 %#ok<BDSCI>
                out = - out; % so that w is non-negative, to ensure that the line drawn is above x-y plane.
            end
            out = vector(out);
            
            
            % below is to find location of the line (with direction known) in space.
            % Finds the intersection of the line with xy plane (if paralle
            % with x-y plane, use x-z plane).
            % uses a 2 by 2 matrix for solving. the derivation is easy.
            n1 = obj.normal; n2 = obj2.normal;
            
            M = [n1 n2]';
            d = [dot(n1,obj.center);dot(n2,obj2.center)];

            id = 'MATLAB:singularMatrix';
            warning('error',id); %#ok<CTPCT>
            
            if W == 0
                try
                    X = M(:,[1 3]) \ d; % this is singular if line is parallel with x-y plane. alternative of do with x-z plane is in the catch block.
                    out = line_(out,[X(1),0,X(2)]);
                catch error %#ok<NASGU>
                    X = M(:,[2 3]) \ d;
                    out = line_(out,[0,X(1),X(2)]);
                end    
            else
                X = M(:,1:2) \ d;
                out = line_(out,[X(1),X(2),0]);
            end                        
        end
    end

end

function [i,j,k,l] = rat4(x,y,z,w)
v = rat_(x,y,z,w);
i = v(1);j = v(2);k = v(3); l = v(4);
end