%% Hamming encoder/decoder
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón
%% hamming_code Encode & decode the incoming bit stream with a kxn Hamming code.
%% 	[out, n, k] = rept_code(in, op, k, n); where in is the input bitstream,
%% 		and k,n parameters of the code.
%% 	op == 'encode' -> encodes input bitstream.
%% 	op == 'decode' -> decodes input bitstream.
%% ERRORS: if the op parameter does not match any option, an error is raised.

function [output_stream, n, k] = hamming_code(input_stream, operation_code, k, n)
	if (strcmp(operation_code, 'encode'))

		return;
	end
	if (strcmp(operation_code, 'decode'))
		return;
	end
	error('Unsupported modulation code.\nSupported operations: "encode", "decode"');
end
