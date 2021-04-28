%% Modulation performance evaluation in AWGN channels
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón

clear; close all;
% number of bits for transmission pseudo-random generated
N = 2*3*4*5*6*7*8*9*10;
bits = rand(1,N)>0.5;

% number of levels of modulation = M
M = [4, 16, 64];
mod_type = ["PSK", "QAM", "QAM"];
max_db_for_representation = [10, 14, 19];
dbEbN0 = 0:15;

% QPSK + 3 and 5 repetition encoding vs raw QPSK
disp('Repetition code testing...');
tic;
errors_r3 = [];
errors_r5 = [];
errors_raw = [];
figure;
for k = dbEbN0
	[bit_energy, ~, err, n0] = transmit(bits, uint64(4), 'PSK', 'repetition', 3, k, 'gray');
	errors_r3 = [errors_r3 err];
	[bit_energy, ~, err, n0] = transmit(bits, uint64(4), 'PSK', 'repetition', 5, k, 'gray');
	errors_r5 = [errors_r5 err];
	[bit_energy, ~, err, n0] = transmit(bits, uint64(4), 'PSK', 'repetition', 0, k, 'gray');
	errors_raw = [errors_raw err];
end
ber3 = sym(errors_r3)/sym(N);
ber5 = sym(errors_r5)/sym(N);
berRaw = sym(errors_raw)/sym(N);
r3 = semilogy(dbEbN0, ber3, '-o');
hold on;
r5 = semilogy(dbEbN0, ber5, '-*');
hold on; 
raw = semilogy(dbEbN0, berRaw, '-d');
grid on;
title('Gray + QPSK raw vs Gray + QPSK + repetition encoding'); xlabel('E_b/N_0(dB)'); ylabel('BER');
legend([r3, r5, raw], 'Repetition encoding r = 3', 'Repetition encoding r = 5', 'Raw QPSK');
toc;

% Hamming encoding
disp('Hamming encoding/decoding testing...');
tic;
errors_qpsk = [];
errors_qam = [];
errors_ham_qpsk = [];
errors_ham_qam = [];
for k = dbEbN0
	[bit_energy, ~, err, n0] = transmit(bits, uint64(4), 'PSK', 'hamming', 7, k, 'gray');
	errors_ham_qpsk = [errors_ham_qpsk err];
	[bit_energy, ~, err, n0] = transmit(bits, uint64(16), 'QAM', 'hamming', 7, k, 'gray');
	errors_ham_qam = [errors_ham_qam err];
	[bit_energy, ~, err, n0] = transmit(bits, uint64(4), 'PSK', 'repetition', 0, k, 'gray');
	errors_qpsk = [errors_qpsk err];
	[bit_energy, ~, err, n0] = transmit(bits, uint64(16), 'QAM', 'repetition', 0, k, 'gray');
	errors_qam = [errors_qam err];
end
ber0 = sym(errors_ham_qpsk)/sym(N);
ber1 = sym(errors_ham_qam)/sym(N);
ber2 = sym(errors_qpsk)/sym(N);
ber3 = sym(errors_qam)/sym(N);
figure;
g0 = semilogy(dbEbN0, ber0, '-o');
hold on; 
g1 = semilogy(dbEbN0, ber1, '-*');
g2 = semilogy(dbEbN0, ber2, '-d');
g3 = semilogy(dbEbN0, ber3, '-s');
grid on;
title('PSK+16QAM vs Hamming(7,4)'); xlabel('E_b/N_0(dB)'); ylabel('BER');
legend([g0, g1, g2, g3], 'QPSK + encoding', '16QAM + encoding', 'QPSK raw', '16QAM raw');
toc;


% First convolutional code
disp('Convolutional I code testing...');
tic;
errors_qpsk = [];
errors_qam = [];
errors_convenc_qpsk = [];
errors_convenc_qam = [];
for k = dbEbN0
	[bit_energy, ~, err, n0] = transmit(bits, uint64(4), 'PSK', 'convolutional-I', 1, k, 'gray');
	errors_convenc_qpsk = [errors_convenc_qpsk err];
	[bit_energy, ~, err, n0] = transmit(bits, uint64(16), 'QAM', 'convolutional-I', 1, k, 'gray');
	errors_convenc_qam = [errors_convenc_qam err];
end
ber0 = sym(errors_convenc_qpsk)/sym(N);
ber1 = sym(errors_convenc_qam)/sym(N);
figure;
g0 = semilogy(dbEbN0, ber0, '-o');
hold on; 
g1 = semilogy(dbEbN0, ber1, '-*');
g2 = semilogy(dbEbN0, ber2, '-d');
g3 = semilogy(dbEbN0, ber3, '-s');
grid on;
title('PSK+16QAM vs 1^{st} convolutional encoding'); xlabel('E_b/N_0(dB)'); ylabel('BER');
legend([g0, g1, g2, g3], 'QPSK + encoding', '16QAM + encoding', 'QPSK raw', '16QAM raw');
toc;

% Second convolutional code
disp('Convolutional II code testing...');
tic;
errors_qpsk = [];
errors_qam = [];
errors_convenc_qpsk = [];
errors_convenc_qam = [];
for k = dbEbN0
	[bit_energy, ~, err, n0] = transmit(bits, uint64(4), 'PSK', 'convolutional-II', 1, k, 'gray');
	errors_convenc_qpsk = [errors_convenc_qpsk err];
	[bit_energy, ~, err, n0] = transmit(bits, uint64(16), 'QAM', 'convolutional-II', 1, k, 'gray');
	errors_convenc_qam = [errors_convenc_qam err];
end
ber0 = sym(errors_convenc_qpsk)/sym(N);
ber1 = sym(errors_convenc_qam)/sym(N);
figure;
g0 = semilogy(dbEbN0, ber0, '-o');
hold on; 
g1 = semilogy(dbEbN0, ber1, '-*');
g2 = semilogy(dbEbN0, ber2, '-d');
g3 = semilogy(dbEbN0, ber3, '-s');
grid on;
title('PSK+16QAM vs 2^{nd} convolutional encoding'); xlabel('E_b/N_0(dB)'); ylabel('BER');
legend([g0, g1, g2, g3], 'QPSK + encoding', '16QAM + encoding', 'QPSK raw', '16QAM raw');
toc;

% Third convolutional code
disp('Convolutional III code testing...');
tic;
errors_qpsk = [];
errors_qam = [];
errors_convenc_qpsk = [];
errors_convenc_qam = [];
for k = dbEbN0
	[bit_energy, ~, err, n0] = transmit(bits, uint64(4), 'PSK', 'convolutional-III', 1, k, 'gray');
	errors_convenc_qpsk = [errors_convenc_qpsk err];
	[bit_energy, ~, err, n0] = transmit(bits, uint64(16), 'QAM', 'convolutional-III', 1, k, 'gray');
	errors_convenc_qam = [errors_convenc_qam err];
end
ber0 = sym(errors_convenc_qpsk)/sym(N);
ber1 = sym(errors_convenc_qam)/sym(N);
figure;
g0 = semilogy(dbEbN0, ber0, '-o');
hold on; 
g1 = semilogy(dbEbN0, ber1, '-*');
g2 = semilogy(dbEbN0, ber2, '-d');
g3 = semilogy(dbEbN0, ber3, '-s');
grid on;
title('PSK+16QAM vs 3^{rd} convolutional encoding'); xlabel('E_b/N_0(dB)'); ylabel('BER');
legend([g0, g1, g2, g3], 'QPSK + encoding', '16QAM + encoding', 'QPSK raw', '16QAM raw');
toc;

