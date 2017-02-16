function soln = burgers( )
	%% Set configurations
	conf = Configuration();

	conf.model = Model.Burgers;
	conf.solver = Flux.Burgers.LaxWen;
	conf.tMax = 0.3;
	conf.CFL = 0.8;
	conf.bc = Mesh.BC.Neumann;
	conf.mesh = Mesh.Cartesian([0,1], 100);
	conf.initial = @(x) (x<0.25) + (x<0.5);
%     conf.initial = @(x) x>0.5;

	%% Run solver and display data
	soln = runSolver(conf);
	Plot.plotSolution(soln);	
end