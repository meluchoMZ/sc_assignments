%% Function that demodulates a M-PAM, M-PSK, M-QAM modulated stream
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón


function demodulated_stream  = demodulate (modulated_stream, modulation_levels, modulation_type)
	% input checking
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

	modulated_stream = double(modulated_stream);
	modulation_levels = double(modulation_levels);
	% input data size check
	[stream_rows, stream_cols] = size(modulated_stream);
	if (stream_rows ~= 1)
		error("<modulated_stream> must be a 1 dimension vector");
	end

	% modulation type checking and modulation computation
	if (strcmp(modulation_type, "PAM"))
		modulation = pam(modulation_levels);
	elseif (strcmp(modulation_type, "PSK"))
		modulation = psk(modulation_levels);
	elseif (strcmp(modulation_type, "QAM"))
		modulation = qam(modulation_levels);
	else
		error('Unsupported modulation type. Supported modulations: PAM, PSK, QAM');
	end
	% vector replication to parallel contrast of input stream
	input_matrix = repmat(modulated_stream, length(modulation), 1);
	% correlate modulated input with PAM modulation
	input_matrix = input_matrix - modulation';
	% get the position to which symbol demodulates
	[~, pos] = min(abs(input_matrix));
	% returning bitstream
	demodulated_stream = logical(reshape(de2bi(pos-1, 'left-msb')', 1, []));
end
