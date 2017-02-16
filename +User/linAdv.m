function soln = linAdv
	%% Set configurations
	conf = Configuration;

	% Create the model object and set the advection speed to 1
	conf.model = Model.LinAdv;
	conf.model.a = 1;

	conf.maxNumWrite = 10000;
	conf.solver = Flux.LinAdv.Upwind;
	conf.reconstr = Reconstr.ENO(4);
	conf.tMax = 0.12566;
	conf.timeInt = @TimeIntegration.RK4;
	conf.CFL = 0.1;
	conf.mesh = Mesh.Cartesian([-pi,pi], 2^8);
	conf.bc = Mesh.BC.Periodic;
 	conf.initial = @(x) sin(x).^4;
	
%     %% Compute errors
%  	exact = Error.exact_linAdv(conf.initial);
% 	Error.calcOOC(conf, exact, 2.^(3:12), [1, 2]);

% 	nx = 2.^(3:10);
% 	n = length(nx);
% 	for k = 1:n
% 		fprintf('numX = %i\n', nx(k,1));
% 		mesh = Mesh.Cartesian(xLim, nx(k,:));
% 		config.mesh = mesh;
% 		soln = runSolver(config);
% 		
% 		dx(k) = mesh.dxMin(1);
% 		[~, U] = soln.getFinal();
% 		uApprox = config.model.getVariable(soln, U, 1);
% % 		uExact = exact(mesh, t, config.useCellAvg);
% % 		uExact = mesh.removeGhostCells(uExact);
% % 		uDiff = uExact - uApprox;
% 		
% 		for j = 1:np
% 			err(j, k) = Error.calcNorm(soln.mesh, uDiff, p(j));
% 			if relative
% 				err(j, k) = err(j, k) / Error.calcNorm(soln.mesh, uExact, p(j));
% 			end
% 		end
% 		
% 		clear soln;
% 	end
    
    %% Run solver and display data
	soln = runSolver(conf);

	% Plot u
% 	Plot.plotSolution(soln);
	
	% Plot processed data
	% Run through time and plot each frame
	fig = figure();
	x = conf.mesh.x;
	nx = length(x);
	dx = conf.mesh.dx{1};
	for itr = 1 : soln.end()
		subplot(1, 2, 1);
		[t, U] = soln.get(itr);		
		u = conf.model.getVariable(soln, U, '');
		k = 4;
		u = diff(u, k) / (factorial(k)*dx^k);		u = [u(end-k+1:end), u];
		plot(x, u, '-o');
		xlim([-pi,pi]);

		subplot(1,2,2);
		% Plot 'r'
		[t, U] = soln.get(itr, false);
		r = User.doENORecon(conf.reconstr.k, U);
		r = conf.mesh.removeGhostCells(r);
		plot(x, r, '-o');
		xlim([-pi,pi]);
		
% 		[t, U] = soln.get(itr, false);
% 		uRecon = conf.reconstr.reconstruct(U, conf.mesh);
% 		uL = uRecon{1};		uR = uRecon{2};
% 		uL = conf.mesh.removeGhostCells(uL);	uR = conf.mesh.removeGhostCells(uR);
% 		xL = x-dx/2; xR = x+dx/2;
		
% 		u = @(x) conf.initial(x-t);
% 		plot(xL, (uL-u(xL))/dx^conf.reconstr.k, '-s');
% 		hold on;
% 		plot(xR, (uR-u(xR))/dx^conf.reconstr.k, '-*');
% 		hold off;
		
% 		xLR(1:2:2*nx) = xL; xLR(2:2:2*nx) = xR;
% 		uLR(1:2:2*nx) = uL;	uLR(2:2:2*nx) = uR;
% 		err = conf.initial(xLR-t)-uLR;
% 		plot(xLR, err/dx^conf.reconstr.k, '-o');
		
% 		plot(xLR, conf.initial(xLR-t), '-o');
% 		hold on;
% 		plot(xLR, uLR, '-s');
% 		hold off;
		fprintf('t=%f\n', t);
% 		title(sprintf('t=%f', t));
		
		% Halt at the first frame
% 		if itr == 1
% 			display('Press any key to continue...');
% 			waitforbuttonpress();
% 		end
		
		drawnow;
	end
end