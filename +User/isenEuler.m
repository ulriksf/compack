function soln = isenEuler
	%% Set configurations
	conf = Configuration();

	conf.model = Model.IsenEuler;
	conf.solver = Flux.Rusanov;
	conf.timeInt = @TimeIntegration.FE;
	conf.tMax = 1;
	conf.CFL = 0.9;
% 	conf.maxNumWrite = 5000;
		
	function ret = initial(x,y)
		midInd = (y>0.25) & (y<0.75);
		rho = ones(size(x));
		m1 = -1 + 2*midInd;
		m2 = zeros(size(x));
		m1 = m1 + rand(size(x))*0.1;
		q = 1 + midInd;
		ret = [rho; m1; m2; q];
	end
	conf.initial = @initial;
	
	conf.bc = Mesh.BC.Periodic;
	conf.mesh = Mesh.Cartesian([0,1;0,1], [100,100]);


	%% Run solver
    soln = runSolver(conf);


	%% Display data, etc.
	Plot.plotSolution(soln, 0, 'm1');
end