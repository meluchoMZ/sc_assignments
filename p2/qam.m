%% Returns a M-QAM modulation vector
%% Communications software, Computer engineering
%% Author: Miguel Blanco Godón

function modulation = qam(modulation_levels, ordering)
	% for modulation using communications toolbox's qammod
	modulation = qammod(0:modulation_levels-1, modulation_levels, ordering);
end
