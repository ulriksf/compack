function [ r ] = doENORecon( k, u )

	% Total number of cells
	n = length(u);

	% Compute undivided difference of the primitive of u

	dd = zeros(k, n);
	dd(1,:) = u;
	for j = 2:k
		dd(j, 1:n+1-j) = dd(j-1, 2:n+2-j) - dd(j-1, 1:n+1-j);
	end


	% Determine r, the left-displacement of index

	r = ones(1, n);
	% Indices to each stencil
	stencils = ones(k, n);
	for m = k : n-k+1
		curR = 0;
		for l = 2:k
			if abs(dd(l, m-curR-1)) <= abs(dd(l, m-curR))
				curR = curR+1;
			end
		end
		stencils(:, m) = m-curR : m-curR + k-1;
		r(m) = curR;
	end

end

