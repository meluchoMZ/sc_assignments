%% Returns a M-PSK modulation vector

function modulation = psk (modulation_levels)
	% creating modulation vector
	modulation = [];
	for k = 0:1:modulation_levels-1
		tita_k = 2*pi*k/modulation_levels;
		modulation = [modulation, sqrt(1/2)*cos(tita_k) + i*sqrt(1/2)*sin(tita_k)];
	end
end
