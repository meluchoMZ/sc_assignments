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
graphx = [];
gray_graphx = [];
theor_graphx = [];
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
	gray_experimental_curve = semilogy(dbEbN0(1:max_db_for_representation(s)), gray_ber(1:max_db_for_representation(s)), '-s');
	theoretical_bit_error_probabilities = theoretical_bit_error_probabilities/log2(M(s));
	theoretical_curve = semilogy(dbEbN0(1:max_db_for_representation(s)), theoretical_bit_error_probabilities(1:max_db_for_representation(s)), '-d');
	title(strcat(string(M(s)), strcat('-',strcat(mod_type(s)))));
	xlabel('E_b/N_0(dB)'); ylabel('BER');
	grid on;
	legend([experimental_curve, gray_experimental_curve, theoretical_curve], strcat(string(M(s)), strcat('-',mod_type(s))),strcat(string(M(s)), strcat('-',strcat(mod_type(s), ' Gray Mapping'))), strcat(string(M(s)), strcat('-',strcat(mod_type(s), ' Theoretical'))));
	graphx = [graphx ber];
	gray_graphx = [gray_graphx gray_ber];
	theor_graphx = [theor_graphx theoretical_bit_error_probabilities];
end

% Now 4 figures will be created comparing several modulations
% BER vs EbN0: BPSK, QPSK, 16-QAM, 64-QAM Gray Mapping
figure;
% BPSK
bpsk = semilogy(dbEbN0, graphx(length(dbEbN0)+1:2*length(dbEbN0)), '-o');
hold on;
% QPSK
qpsk = semilogy(dbEbN0, graphx(2*length(dbEbN0)+1:3*length(dbEbN0)), '-s');
% 16-QAM
qam16 = semilogy(dbEbN0, graphx(3*length(dbEbN0)+1:4*length(dbEbN0)), '-*');
% 64-QAM
qam64 = semilogy(dbEbN0, graphx(4*length(dbEbN0)+1:5*length(dbEbN0)), '-d');
title('BER vs E_b/N_0: Gray Mapping');xlabel('E_b/N_0'); ylabel('BER');
legend([bpsk, qpsk, qam16, qam64], 'BPSK', 'QPSK', '16-QAM', '64-QAM');
grid on;

% BER vs EbN0: BPSK natural, QPSK natural, QPSK Gray Mapping QPSK Theoretical 
figure;
% BPSK
bpsk_n = semilogy(dbEbN0, graphx(length(dbEbN0)+1:2*length(dbEbN0)), '-o');
hold on; 
% QPSK
qpsk_n = semilogy(dbEbN0, graphx(2*length(dbEbN0)+1:3*length(dbEbN0)), '-s');
% 16-QAM
qpsk_g = semilogy(dbEbN0, gray_graphx(2*length(dbEbN0)+1:3*length(dbEbN0)),'-*');
% 64-QAM
qpsk_t = semilogy(dbEbN0, theor_graphx(2*length(dbEbN0)+1:3*length(dbEbN0)), '-d');
title('BER vs E_b/N_0: PSK');xlabel('E_b/N_0'); ylabel('BER');
legend([bpsk_n, qpsk_n, qpsk_g, qpsk_t], 'BPSK natural', 'QPSK natural', 'QPSK Gray Mapping', 'QPSK Theoretical');
grid on;

% BER vs EbN0: 16-QAM natural, 16-QAM Gray Mapping, 16-QAM theoretical
figure;
% BPSK
qam16_n = semilogy(dbEbN0, graphx(3*length(dbEbN0)+1:4*length(dbEbN0)),'-o');
hold on; 
% QPSK
qam16_g = semilogy(dbEbN0, gray_graphx(3*length(dbEbN0)+1:4*length(dbEbN0)), '-s');
% 16-QAM
qam16_t = semilogy(dbEbN0, theor_graphx(3*length(dbEbN0)+1:4*length(dbEbN0)), '-d');
% 64-QAM
title('BER vs E_b/N_0: 16-QAM');xlabel('E_b/N_0'); ylabel('BER');
legend([qam16_n, qam16_g, qam16_t], '16-QAM natural', '16-QAM Gray Mapping', '16-QAM Theoretical');
grid on;

% BER vs EbN0: 64-QAM natural, 64-QAM Gray Mapping, 64-QAM Theoretical 
figure;
% BPSK
qam64_n = semilogy(dbEbN0, graphx(4*length(dbEbN0)+1:5*length(dbEbN0)), '-o');
hold on;
% QPSK
qam64_g = semilogy(dbEbN0, gray_graphx(4*length(dbEbN0)+1:5*length(dbEbN0)), '-s');
% 16-QAM
qam64_t = semilogy(dbEbN0, theor_graphx(4*length(dbEbN0)+1:5*length(dbEbN0)), '-d');
% 64-QAM
title('BER vs E_b/N_0: 64-QAM');xlabel('E_b/N_0'); ylabel('BER');
legend([qam64_n, qam64_g, qam64_t], '64-QAM natural', '64-QAM Gray Mapping', '64-QAM Theoretical');
grid on;
