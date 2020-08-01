classdef directionUVW < millerUVW
    %direction object in [UVW] index form. subclass of millerUVW. provides
    %conversion to uvtw format.
    
    properties
    end
    
    methods
        function obj = directionUVW(varargin)
            obj = obj@millerUVW(varargin{:});
        end
        
        function out = ctranspose(obj) % conversion to [uvtw] format.
            u = (2*obj.U - obj.V)/3;
            v = (2*obj.V - obj.U)/3;
            w = obj.W;
            
            if ~(isint_(u)&&isint_(v))
                u = u*3; v = v*3; w = w*3;
            end
            out = direction(u,v,-u-v,w);
        end
    end
    
end

function TF = isint_( in )
TF = (abs(nearest(in) - in) < 1e-6);
end