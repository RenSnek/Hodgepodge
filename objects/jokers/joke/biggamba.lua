SMODS.Joker {
    key = "biggamba",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {card.ability.x_chips}
        }
    end,
    config = {
        extra = {
            max = 300,
            min = -100,
            jackpot = 10000
        }
    },
    atlas = "jokers_atlas",
    pos = {x=9,y=HODGE.atlas_y.joke[1]},
    --soul_pos = {x=13,y=HODGE.atlas_y.soul[3]},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.joker_main then
            if SMODS.pseudorandom_probability(card, 'biggamba', 1, 100, 'biggamba') then
                return {
                    message = "Jackpot!",
                    chips = card.ability.extra.jackpot
                }
            end
            return {
                chips = pseudorandom("biggamba",card.ability.extra.min,card.ability.extra.max)
            }
        end
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','joke')
    end
}

