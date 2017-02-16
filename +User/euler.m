function soln = euler
	%% Set configurations
	conf = Configuration();

	conf.model = Model.Euler;
	conf.solver = Flux.Rusanov;
	conf.timeInt = @TimeIntegration.FE;
	conf.tMax = 0.8;
	conf.CFL = 0.9;
	conf.maxNumWrite = 5000;
		
	% 1D example
	function ret = initial(x)
		rho = 1 + (x>0);
		u = zeros(size(x));
		v = zeros(size(x));
		p = 1 + 2*(x>0);
		[m1, m2, e] = conf.model.primToCons(rho, u, v, p);
		ret = [rho; m1; m2; e];
	end
	conf.initial = @initial;
	
	conf.bc = Mesh.BC.Neumann;
	conf.mesh = Mesh.Cartesian([-2,2], 100);


	%% Run solver
    soln = runSolver(conf);


	%% Display data, etc.
	Plot.plotSolution(soln, 0, 'density');	
end