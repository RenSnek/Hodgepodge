SMODS.Joker {
    key = "vestup",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {card.ability.chips,card.ability.extra.chip_gain_bonus,card.ability.extra.increase}
        }
    end,
    config = {
        chips = 4,
        extra = {
            chip_gain_bonus = 1,
            increase = 1
        }
    },
    atlas = "jokers_atlas",
    pos = {x=5,y=HODGE.atlas_y.joke[1]},
    soul_pos = {x=5,y=HODGE.atlas_y.soul[2]},
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                chips = card.ability.chips
            }
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.chip_gain_bonus = card.ability.extra.chip_gain_bonus + card.ability.extra.increase
            return {
                message = "Vest Up!"
            }
        end
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','joke')
    end
}