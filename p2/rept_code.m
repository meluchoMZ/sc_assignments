%% Repetition code encoder/decoder
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón
%% rept_code Encode & decode the incoming bit stream with a rate 1/R repeat code.
%% 	[out, n, k] = rept_code(in, op, R); where in is the input bitstream,
%% 		and R = n/k, the number of repetitions per bit.
%% 	op == 'encode' -> encodes input bitstream.
%% 	op == 'decode' -> decodes input bitstream.
%% ERRORS: if the op parameter does not match any option, an error is raised.

function [output_stream, n, k] = rept_code(input_stream, operation_code, R)
	n = R; k = 1;
	if (strcmp(operation_code, 'encode'))
		output_stream = reshape(repmat(input_stream, R, 1), 1, []);
		return;
	end
	if (strcmp(operation_code, 'decode'))
		output_stream = sum(reshape(input_stream, R, []))>(R/2);
		return;
	end
	error('Unsupported modulation code.\nSupported operations: "encode", "decode"');
end
