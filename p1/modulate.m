%% Function that modulates a bit stream into M-PAM, M-PSK, M-QAM, M-QAM modulated stream
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón


function [modulated_stream, modulation_type, dimension, complex] = modulate (input_bitstream, modulation_levels, modulation_type)
	% input checking
	if (~isa(input_bitstream, 'logical'))
		error('<input_bitstream> must be a logical vector');
	end
	if (~isa(modulation_levels, 'uint8')&~isa(modulation_levels, 'uint16')&~isa(modulation_levels, 'uint32')&~isa(modulation_levels, 'uint64'))
		error('<modulation_levels> must be a positive integer power of 2');
	end
	if (size(modulation_levels) ~= [1 1])
		error('<modulation_levels> must be a positive integer power of 2 value, not vector or matrix');
	end
	% checking if modulation_levels is a power of 2
	syms ml; tolerancy = 1e-12; sol = solve(2^ml==modulation_levels, ml);
	if (~ismembertol(double(round(sol)), double(sol), tolerancy))
		error('<modulation_levels> must be a power of 2');
	end
	% converting to 64 bits unsigned integer to proper calculations
	modulation_levels = uint64(modulation_levels);
	if (~isa(modulation_type, 'string') & ~isa(modulation_type, 'char'))
		error('<modulation_type> must be a string or char sequence');
	end
	
	% modulation type checking and modulation computation
	if (strcmp(modulation_type, "PAM"))
		modulated_stream = modulate_PAM(input_bitstream, modulation_levels);
		modulation_type = strcat(string(modulation_levels), strcat('-', modulation_type));
		dimension = 1;
		complex = false;
	elseif (strcmp(modulation_type, "PSK"))
		modulated_stream = modulate_PSK(input_bitstream, modulation_levels);
		modulation_type = strcat(string(modulation_levels), strcat('-', modulation_type));
		dimension = 2;
		complex = true;
	elseif (strcmp(modulation_type, "QAM"))
		modulated_stream = modulate_QAM(input_bitstream, modulation_levels);
		modulation_type = strcat(string(modulation_levels), strcat('-', modulation_type));
		dimension = 2; 
		complex = true;
	else
		error('Unsupported modulation type. Supported modulations: PAM, PSK, QAM');
	end
end

function modulated_stream = modulate_PAM (input_bitstream, modulation_levels)
	input_bitstream = double(input_bitstream);
	modulation_levels = double(modulation_levels);
	% input data size check
	[bitstream_rows, bitstream_cols] = size(input_bitstream);
	if (bitstream_rows ~= 1)
		error("<input_bitstream> must be a 1 dimension vector");
	end
	if (mod(bitstream_cols, log2(modulation_levels)) ~= 0)
		error("<input_bitstream> length must be multiple of <modulation_levels>");
	end
	% creating modulation vector
	modulation = [];
	for k = 0:1:modulation_levels-1
		modulation = [modulation, 2*k+1-modulation_levels];
	end
	% reshaping matrix so that it fits the number of bits/symbol
	input_matrix = reshape(input_bitstream, log2(modulation_levels), []);
	% modulation_computation
	modulated_stream = modulation(bi2de(input_matrix', 'left-msb')+1);
end

function modulated_stream = modulate_PSK (input_bitstream, modulation_levels)
	modulated_stream = "PSK modulated stream";
end

function modulated_stream = modulate_QAM (input_bitstream, modulation_levels)
	modulated_stream = "QAM modulated stream";
end
