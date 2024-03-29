%% Data transmission through AWGN channel
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón

function [bit_energy, symbol_energy, errors, N0] = transmit (input_stream, modulation_levels, modulation_type, encoding_type, code_size, dbEbN0, ordering)
	if (code_size ~= 0)
		% encodes input stream
		if (strcmp(encoding_type, 'repetition'))
			[encoded_stream, n, k] = rept_code(input_stream, 'encode', code_size);
		elseif (strcmp(encoding_type, 'hamming'))
			[encoded_stream, n, k] = hamming_code(input_stream, 'encode', code_size);
			encoded_stream = logical(encoded_stream);
		elseif (strcmp(encoding_type, 'convolutional-I'))
			trellis = poly2trellis(3, [7 5 6]);
			encoded_stream = convenc(input_stream, trellis);
			k = log2(trellis.numInputSymbols);
			n = log2(trellis.numOutputSymbols);
		elseif (strcmp(encoding_type, 'convolutional-II'))
			trellis = poly2trellis(3, [3 5 6]);
			encoded_stream = convenc(input_stream, trellis);
			k = log2(trellis.numInputSymbols);
			n = log2(trellis.numOutputSymbols);
		elseif (strcmp(encoding_type, 'convolutional-III'))
			% to augment the encodig gain, encoding length is augmented
			trellis = poly2trellis(4, [17, 13, 15, 11]);
			encoded_stream = convenc(input_stream, trellis);
			k = log2(trellis.numInputSymbols);
			n = log2(trellis.numOutputSymbols);
		else 
			error('Unsupported encoding type');
		end
	else 
		encoded_stream = input_stream;
		k = 0; n = 1;
	end

	% modulates input stream
	[modulated_stream, modulation, dimension, complex] = modulate(encoded_stream, modulation_levels, modulation_type, ordering);
	% sends modulated stream over an AWGN channel
	[recv_stream, bit_energy, symbol_energy, N0] = awgn(modulated_stream, uint64(log2(double(modulation_levels))), uint64(dimension), complex, dbEbN0, k/n);
	% demodulates received stream
	demodulated_stream = demodulate(recv_stream, modulation_levels, modulation_type, ordering);
	% decodes input stream
	if (code_size ~= 0)
		if (strcmp(encoding_type, 'repetition'))
			[output_stream, n, k] = rept_code(demodulated_stream, 'decode', code_size);
		elseif (strcmp(encoding_type, 'hamming'))
			[output_stream, n, k] = hamming_code(demodulated_stream, 'decode', code_size);
		elseif (strcmp(encoding_type, 'convolutional-I'))
			trellis = poly2trellis(3, [7 5 6]);
			output_stream = vitdec(demodulated_stream, trellis, 15, 'trunc', 'hard');
		elseif (strcmp(encoding_type, 'convolutional-II'))
			trellis = poly2trellis(3, [3 5 6]);
			output_stream = vitdec(demodulated_stream, trellis, 15, 'trunc', 'hard');
		elseif (strcmp(encoding_type, 'convolutional-III'))
			trellis = poly2trellis(4, [17 13 15 11]);
			output_stream = vitdec(demodulated_stream, trellis, 20, 'trunc', 'hard');
		else
			error('Unsupported encoding type');
		end
	else 
		output_stream = demodulated_stream;
	end
	% error computing
	errors = sum(~(input_stream == output_stream));
end
