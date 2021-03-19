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
max_db_for_representation = [14, 10, 10, 14, 19];
syms m eb N0;
dbEbN0 = 0:20;
ber_prob = [((m-1)/m)*erfc(sqrt((3*log2(m)*eb)/((m^2-1)*N0))), ((m-1)/m)*erfc(sqrt((3*log2(m)*eb)/((m^2-1)*N0))), erfc(sqrt(eb/N0))*(m/m), 2*((sqrt(m)-1)/sqrt(m))*erfc(sqrt((3*log2(m)*eb)/(2*(m-1)*N0))), 2*((sqrt(m)-1)/sqrt(m))*erfc(sqrt((3*log2(m)*eb)/(2*(m-1)*N0)))];
for s = 1:length(M)
	errors = []; ebs = []; N0s = []; gray_err = [];
	theoretical_bit_error_probabilities = ones(1,length(dbEbN0));
	for k = dbEbN0
		[bit_energy,~ , err, n0] = transmit(bits, uint64(M(s)), mod_type(s), k, 'bin');
		errors = [errors err]; ebs = [ebs bit_energy]; N0s = [N0s n0];
		index = find(dbEbN0==k);
		theoretical_bit_error_probabilities(index) = subs(theoretical_bit_error_probabilities(index)*ber_prob(s), {m,eb,N0}, {M(s), ebs(index), N0s(index)});
		[~, ~, gray_errors, ~] = transmit(bits, uint64(M(s)), mod_type(s), k, 'gray');
		gray_err = [gray_err gray_errors];
	end
	ber = sym(errors) / sym(N);
	gray_ber = sym(gray_err)/sym(N);
	figure;
	experimental_curve = semilogy(dbEbN0(1:max_db_for_representation(s)), ber(1:max_db_for_representation(s)), '-o');
	hold on;
	gray_experimental_curve = semilogy(dbEbN0(1:max_db_for_representation(s)), gray_ber(1:max_db_for_representation(s)), '-+');
	theoretical_bit_error_probabilities = theoretical_bit_error_probabilities/log2(M(s));
	theoretical_curve = semilogy(dbEbN0(1:max_db_for_representation(s)), theoretical_bit_error_probabilities(1:max_db_for_representation(s)), '-x');
	xlabel('E_b/N_0(dB)'); ylabel('BER');
	grid on;
	%legend(strcat(string(M(s)),strcat('-',mod_type(s))));
	legend([experimental_curve, gray_experimental_curve, theoretical_curve], strcat(string(M(s)), strcat('-',mod_type(s))),strcat(string(M(s)), strcat('-',strcat(mod_type(s), ' Gray Mapping'))), strcat(string(M(s)), strcat('-',strcat(mod_type(s), ' Theoretical'))));
end
