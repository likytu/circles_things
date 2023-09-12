function get_difficulty (amount, period)
    return math.floor(1000* math.pow(amount, 2) * math.log(amount) / period)
end
function get_scaling_effect_hp (newgame_n, scaling_effect)
    return (1 + 2*math.pow(newgame_n, 2)) * scaling_effect
end
function get_scaling_effect_attack_speed (newgame_n, scaling_effect)
    return (math.pow( 0.5, newgame_n )) / scaling_effect
end