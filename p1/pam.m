%% Returns a M-PAM modulation vector

function modulation = pam (modulation_levels)
	% creating modulation vector
	modulation = [];
	for k = 0:1:modulation_levels-1
		modulation = [modulation, 2*k+1-modulation_levels];
	end
end
