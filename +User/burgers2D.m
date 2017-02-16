function soln = burgers2D( )
	%% Set configurations
	conf = Configuration();

	conf.model = Model.Burgers;
	conf.solver = Flux.LaxFr;
	conf.tMax = 0.4;
	conf.tInclude = [0 0.1 0.2 0.3 0.4];
	conf.CFL = 0.4;
	conf.bc = Mesh.BC.Neumann;
	nx = 256;
	conf.mesh = Mesh.Cartesian([-0.5,0.5;-0.5,0.5], [nx,nx]);
	k = [3, 6, 8];
	a = rand(size(k))*0.01;
	function u = initial(x, y)
		theta = atan2(y, x);
		rSq = x.^2+y.^2;
		for i=1:length(k)
			rSq = rSq + a(i)*cos(k(i)*theta);
		end
		u = rSq < 0.05;
	end
	conf.initial = @initial;
% 	conf.initial = @(x,y) (x.^2+y.^2)<0.05;
%     conf.initial = @(x) x^2 < 0.1;

	%% Run solver and display data
	soln = runSolver(conf);
% 	Plot.plotSolution(soln);
	figure();
	for t = conf.tInclude
		[~, U] = soln.getAtTime(t);
		Plot.plotFrame(soln, U, t, [0,1]);
		title('');	xlabel('');		ylabel('');
		Plot.makeNice;
		Plot.saveFig(sprintf('burgers2D_nx=%d_t=%d_p3', nx, t*10));
	end
end