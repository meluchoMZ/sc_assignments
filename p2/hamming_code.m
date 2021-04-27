%% Hamming encoder/decoder
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón
%% hamming_code Encode & decode the incoming bit stream with a kxn Hamming code.
%% 	[out, n, k] = rept_code(in, op, n); where in is the input bitstream,
%% 		and k,n parameters of the code. MINIMUM n = 7, all n = 2^l-1
%% 	op == 'encode' -> encodes input bitstream.
%% 	op == 'decode' -> decodes input bitstream.
%% ERRORS: if the op parameter does not match any option, an error is raised.

function [output_stream, n, k] = hamming_code(input_stream, operation_code, n)
	H = de2bi(1:n, 'right-msb')'; 
	G = generatrix(H); 
	[k, n] = size(G);
	if (strcmp(operation_code, 'encode'))
		raw = reshape(input_stream, k, [])';
		encoded = mod(raw*G, 2);
		output_stream = reshape(encoded', 1, []);
		return;
	end
	if (strcmp(operation_code, 'decode'))
		encoded = reshape(input_stream, n, [])';
		sindrom = mod(encoded*H', 2);
		errors = bi2de(sindrom, 'right-msb');
		error_indexes = []; ii = 1;
		while (ii <= length(errors))
			if (errors(ii) ~= 0)
				error_indexes = [error_indexes ii];
			end
			ii = ii+1;
		end
		errors(errors==0) = [];
		%encoded(error_indexes, errors) = ~encoded(error_indexes, errors);
		for jj = 1:length(errors)
			encoded(error_indexes(jj),errors(jj)) = ~encoded(error_indexes(jj),errors(jj));
		end
		a = []; ii = 0;
		while (2^ii <= n)
			a = [a 2^ii];
			ii = ii + 1;
		end
		encoded(:, a) = [];
		output_stream = reshape(encoded', 1, []);
		return;
	end
	error('Unsupported operation. Supported operations: "encode", "decode"');
end

%% Creates the generator matrix G acording to the parity check matrix H
function G = generatrix(h)
	[l, n] = size(h);
	k = n - l;
	ii = 0;
	% a will contain the indexes of the basis, needed for column permutation
	a = [];
	while (2^ii <= n)
		a = [a 2^ii];
		ii = ii+1;
	end
	% b will contain the indexes of columns that will be permutated with 'a' indexes 
	b = n+1-length(a):n;
	% column permutation
	h(:, a) = h(:, b);
	% remove I(lxl) of the matrix 
	pt = h(:, 1:n-length(a));
	pt(:, a) = []; % only non permutated column indexes will remain
	% non permutated columns indexes creation
	pts = 1:n;
	pts(:, b) = [];
	pts(:, a) = [];
	% reconstruction of Pt
	pt = [pt h(:, a)];
	% G for h', lineal block equivalent code
	Gpnp = [eye(k) pt'];
	G = Gpnp;
	% Permutation inversion, obtaining G for the given H
	G(:, pts) = G(:, 1:length(pts));
	G(:, a) = Gpnp(:, b);
	G(:, b) = Gpnp(:, length(pts)+1:length(pts)+length(a));
end
