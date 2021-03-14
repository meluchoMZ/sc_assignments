%% Additive White Gaussian Noise channel simulation
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón

function [noisy_modulated_stream, bit_energy, symbol_energy] = awgn (modulated_stream, bits_per_symbol, dimension, complex, dbEbN0)
	if (~isa(dimension, 'uint8')&~isa(dimension, 'uint16')&~isa(dimension, 'uint32')&~isa(dimension, 'uint64'))
		error('<dimension> must be a an unsigned integer');
	end
	if (~isa(bits_per_symbol, 'uint8')&~isa(bits_per_symbol, 'uint16')&~isa(bits_per_symbol, 'uint32')&~isa(bits_per_symbol, 'uint64'))
		error('<bits_per_symbol> must be positive integer non zero value');
	end
	if ((size(bits_per_symbol) ~= [1 1])|(bits_per_symbol == 0))
		error('<bits_per_symbol> must be a positive non zero integer value (non vector)');
	end
	if (~isa(complex, 'logical'))
		error('<complex> must be a logical value');
	end
	if (size(dbEbN0) ~= [1 1])
		error('<dbEbN0> must be a non vector value in dB');
	end
	if (dimension == 0) 
		error('can not work with zero dimenison vectors');
	end
	% compute symbol energy
	symbol_energy = mean(abs(modulated_stream).^2);
	% compute bit energy
	bit_energy = symbol_energy / double(bits_per_symbol);
	% compute N0 
	N0 = bit_energy / (10^(dbEbN0/10));

	if (dimension == 1)
		% creates gaussian noise with mean 0 and tipic deviation N0/2
		noise = sqrt(N0/2) * randn(size(modulated_stream));
		% adds noise to the modulated stream
		noisy_modulated_stream = modulated_stream + noise;
	elseif ((dimension == 2) & complex)
		% creates gaussian noise with mean 0 and tipic deviation N0/2
		real_noise = sqrt(N0/2) * randn(size(modulated_stream));
		imag_noise = sqrt(N0/2) * randn(size(modulated_stream))*1j;
		noisy_modulated_stream = modulated_stream + real_noise + imag_noise;
	end
end
