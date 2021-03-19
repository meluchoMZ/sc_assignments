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
syms m eb N0;
dbEbN0 = 0:14;
ber_prob = [((m-1)/m)*erfc(sqrt((3*log2(m)*eb)/((m^2-1)*N0))), erfc(sqrt(eb/N0))*(m/m), erfc(sqrt(eb/N0))*(m/m), 2*((sqrt(m)-1)/sqrt(m))*erfc(sqrt((3*log2(m)*eb)/(2*(m-1)*N0))), 2*((sqrt(m)-1)/sqrt(m))*erfc(sqrt((3*log2(m)*eb)/(2*(m-1)*N0)))];
for s = 1:length(M)
	errors = []; ebs = []; N0s = [];
	theoretical_bit_error_probabilities = ones(1,length(dbEbN0));
	for k = dbEbN0
		[bit_energy,~ , err, n0] = transmit(bits, uint64(M(s)), mod_type(s), k);
		errors = [errors err]; ebs = [ebs bit_energy]; N0s = [N0s n0];
		index = find(dbEbN0==k);
		theoretical_bit_error_probabilities(index) = subs(theoretical_bit_error_probabilities(index)*ber_prob(s), {m,eb,N0}, {M(s), ebs(index), N0s(index)});
	end
	ber = errors / N;
	figure;
	experimental_curve = semilogy(dbEbN0, ber, '-o');
	hold on;
	theoretical_curve = semilogy(dbEbN0, theoretical_bit_error_probabilities, '-x');
	xlabel('E_b/N_0(dB)'); ylabel('BER');
	grid on;
	%legend(strcat(string(M(s)),strcat('-',mod_type(s))));
	legend([experimental_curve, theoretical_curve], strcat(string(M(s)), strcat('-',mod_type(s))), strcat(string(M(s)), strcat('-',strcat(mod_type(s), ' teórica'))));
end
