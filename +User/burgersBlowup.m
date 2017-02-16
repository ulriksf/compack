function burgersBlowup( )
	%% Set solver configurations
	conf = Configuration();
	conf.maxNumWrite = 50;

	conf.useCellAvg = false;
	conf.model = Model.Burgers;
% 	conf.solver = Flux.Burgers.Godunov;
	conf.solver = Flux.Rusanov;
	conf.source = User.BurgersForce;
	
	conf.timeInt = @TimeIntegration.FE;
	conf.tMax = 0.95;
	conf.CFL = 0.1;
	
	exact = @(t,x) (1-t)./(abs(x)+(1-t).^2);
	conf.bc = Mesh.BC.Periodic;
	conf.initial = @(x) exact(0,x);
	conf.mesh = Mesh.Cartesian([-1, 1], 301);
	
	
	%% Set GYM configurations
	nrefine = 1;
	R = 10;
	nu = cell(1,nrefine);
	nuinf = cell(1,nrefine);
	m = cell(1,nrefine);
	x = cell(1,nrefine);

	
	%% Run simulation
	for i = 1:nrefine
		soln = runSolver(conf);
		
		[~,u] = soln.getFinal();
		ind = abs(u)<R;
		nu{i} = zeros(size(u));
		nu{i}(ind) = u(ind);
		nuinf{i} = zeros(size(u));
		nuinf{i}(~ind) = u(~ind) ./ abs(u(~ind));
		m{i} = zeros(size(u));
		m{i}(~ind) = u(~ind);
		x{i} = soln.mesh.x;
		
		% Plot solution
		Plot.plotSolution(soln, 0, 1, exact, false);
		
		% Refine the mesh for the next simulation
		conf.mesh = conf.mesh.refine();
	end
end