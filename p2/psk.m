%% Returns a M-PSK modulation vector
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón

function modulation = psk (modulation_levels, ordering)
	% creating modulation vector
	modulation = [];
	for k = 0:1:modulation_levels-1
		tita_k = 2*pi*k/modulation_levels;
		modulation = [modulation, sqrt(1/2)*cos(tita_k) + (sqrt(1/2)*sin(tita_k))*i];
	end
	% gray mapping
	if (strcmp(ordering, 'gray'))
		modulation = [modulation(1:length(modulation)/2), fliplr(modulation(length(modulation)/2+1:length(modulation)))];
	end
end
