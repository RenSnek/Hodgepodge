SMODS.Joker {
    key = "nonejoker",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {card.ability.extra.equals_mult,card.ability.extra.x_chips}
        }
    end,
    config = {
        extra = {
            x_chips = 4,
            equals_mult = 1
        }
    },
    atlas = "jokers_atlas",
    pos = {x=13,y=HODGE.atlas_y.joke[1]},
    soul_pos = {x=13,y=HODGE.atlas_y.soul[3]},
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                mult = card.ability.extra.equals_mult-mult,
                xchips = card.ability.extra.x_chips
            }
        end
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','joke')
    end
}

