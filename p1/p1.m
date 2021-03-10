%% Modulation performance evaluation in AWGN channels
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón

clear; close all;
% number of bits for transmission pseudo-random generated
N = 10^7;
bits = rand(1,N)>0.5;

% 4-PAM modulation
% number of levels of modulation = M
M = 4;
mod_type = "PAM";
dbEbN0 = 0:14;
errors = [];
for k = dbEbN0
	[~, ~, err] = transmit(bits, uint64(M), mod_type, k);
	errors = [errors err];
end
ber = errors / N;
figure;
semilogy(dbEbN0, ber, '-o');
xlabel('Eb/N0(dB)'); ylabel('BER');
grid on;
legend(strcat(string(M),strcat('-',mod_type)));
% BPSK modulation
M = 2;
mod_type = "PSK";
dbEbN0 = 0:10;
errors = [];
for k = dbEbN0
	[~, ~, err] = transmit(bits, uint64(M), mod_type, k);
	errors = [errors err];
end
ber = errors / N;
figure;
semilogy(dbEbN0, ber, '-o');
legend(strcat(string(M),strcat('-', mod_type)));
xlabel('Eb/N0(dB)'); ylabel('BER');
grid on;
