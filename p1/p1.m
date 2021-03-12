%% Modulation performance evaluation in AWGN channels
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón

clear; close all;
% number of bits for transmission pseudo-random generated
N = 7200000;
bits = rand(1,N)>0.5;

% number of levels of modulation = M
M = [4, 2, 4, 16, 64];
mod_type = ["PAM", "PSK", "PSK", "QAM", "QAM"];
dbEbN0 = 0:14;
for s = 1:length(M)
	errors = [];
	for k = dbEbN0
		[~, ~, err] = transmit(bits, uint64(M(s)), mod_type(s), k);
		errors = [errors err];
	end
	ber = errors / N;
	figure;
	semilogy(dbEbN0, ber, '-o');
	xlabel('Eb/N0(dB)'); ylabel('BER');
	grid on;
	legend(strcat(string(M(s)),strcat('-',mod_type(s))));
end
