classdef millerUVW
    %alternate format of miller index, utilizing 3 indices. Provides
    %conversion to miller.
    
    properties
        U = 0;
        V = 0;
        W = 0;
    end
    
    methods
        function obj = millerUVW(U,V,W)
            if nargin == 0
                return; end;
            obj.U = U; obj.V = V; obj.W = W;
        end
    end
    
    methods (Abstract)
        ctranspose(obj) % convert to miller object. method depends on object type (plane or direction).
    end
    
end

