classdef planeUVW < millerUVW
    %plane of UVW index form. provides conversion to uvtw format.
    
    properties
    end
    
    methods
        function obj = planeUVW(varargin)
            obj = obj@millerUVW(varargin{:});
        end
        
        function out = ctranspose(obj)
            out = simplePlane(obj.U,obj.V,-(obj.U+obj.V),obj.W);
        end
    end
    
end