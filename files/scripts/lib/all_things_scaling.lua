function get_difficulty (amount, period, immunities_removed)
    return math.floor(math.pow(1.38, math.floor(immunities_removed+0.5)-1) * 1000* math.pow(amount, 2) * math.log(amount) / math.pow(period, math.sqrt(1.5)))
end
function get_scaling_effect_hp (newgame_n, scaling_effect)
    return (0.8 * math.exp(newgame_n)) * scaling_effect
end
function get_scaling_effect_attack_speed (newgame_n, scaling_effect)
    return (math.pow( 0.5, newgame_n )) / scaling_effect * 1.3
end