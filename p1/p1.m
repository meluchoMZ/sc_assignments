%% Modulation performance evaluation in AWGN channels
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón


% number of bits for transmission pseudo-random generated
N = 12;
bits = rand(1,N)>0.5;

% 4-PAM modulation
% number of levels of modulation = M
M = 4;
mod_type = "PAM";
%recv_bits = transmit(bits, M, mod_type);
modulate(bits, uint8(4), "PAM")
