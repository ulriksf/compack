classdef BurgersForce < Source.SourceBase
%BURGERSFORCE   Source term to force the solution to a specific function.
%   If the initial data is chosen to be a specific function (see source())
%   then this source term will force the (exact) solution to stay constant
%   in time.
	
	properties(Access = private)
		mesh
	end
	
	properties
	end
	
	
	methods
		function initialize(o, config)
			o.mesh = config.mesh;
		end
		
		
		function ret = source(o, U, UR, t, dt)
			ret = zeros(size(U));
			theta = 1-t;
			
			x = o.mesh.x;
			ret(o.mesh.internal) = -1*(abs(x)-theta^2) ./ (abs(x)+theta^2).^2 - theta^2*sign(x)./(abs(x)+theta^2).^3;

% 			x = o.mesh.xEdges;
% 			F = -sign(x).*(log((abs(x)+theta^2)/theta^2) - 2*abs(x)./(abs(x)+theta^2)) + (theta./(abs(x)+theta^2)).^2/2;
% 			ret(o.mesh.internal) = diff(F) / (x(2)-x(1));
			
% 			[m,I] = max(abs(ret(o.mesh.internal)));
% 			fprintf('%e\t %d\n', m, I);
% 			if max(abs(ret)) > 5e2
% 			end
		end
	end
end