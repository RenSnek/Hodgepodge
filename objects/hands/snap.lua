SMODS.PokerHand {
    key = "snap",
    mult = 2,
    chips = 30,
    l_mult = 2,
    l_chips = 15,
    example = {
        { 'S_5', false},
        { 'S_5', true, enhancement = 'm_lucky'},
        { 'S_5', true, enhancement = 'm_lucky'},
        { 'S_5', false, enhancement = 'm_gold'},
        { 'D_5', false, enhancement = 'm_lucky'},
    },
    visible = true,
    evaluate = function(parts,hand)
        for k,pair in ipairs(parts._2) do
            if #pair == 2 then --filter out 3oaks, 4oaks, 5oaks
                if pair[1].base.name == pair[2].base.name and pair[1].ability.name == pair[2].ability.name then
                    return {pair}
                end
            end
        end
        return {}
    end
}