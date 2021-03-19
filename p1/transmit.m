%% Data transmission through AWGN channel
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón

function [bit_energy, symbol_energy, errors, N0] = transmit (input_stream, modulation_levels, modulation_type, dbEbN0)
	% modulates input stream
	[modulated_stream, modulation, dimension, complex] = modulate(input_stream, modulation_levels, modulation_type);
	% sends modulated stream over an AWGN channel
	[recv_stream, bit_energy, symbol_energy, N0] = awgn(modulated_stream, uint64(log2(double(modulation_levels))), uint64(dimension), complex, dbEbN0);
	% demodulates received stream
	output_stream = demodulate(recv_stream, modulation_levels, modulation_type);
	errors = sum(~(input_stream == output_stream));
%%	input_stream
%%	modulated_stream
%%	recv_stream
%%	output_stream
end
