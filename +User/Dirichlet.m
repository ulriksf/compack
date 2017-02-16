classdef Dirichlet
	%DIRICHLET   Dirichlet boundary conditions.
	
	properties(Access = private)
		g
	end
	
	
	methods
		function o = Dirichlet(g)
			o.g = g;
		end
		
		function U = updateBoundary(o, U, mesh, t)
			ngc = mesh.ngc;
			nx = mesh.nx;
			ndims = mesh.ndims;
			x = mesh.x;
			
			if ndims == 1
				for m = 1:ngc
					U(:, m) = o.g(t, x(1));
					U(:, nx(1)+ngc+m, :) = o.g(t, x(end));
				end
			end
			if ndims >= 2
				error('Only implemented for 1D');
			end
		end
	end	
end