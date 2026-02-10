SMODS.Joker {
    key = "vestup",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {card.ability.extra.chips,card.ability.extra.chip_gain_bonus,card.ability.extra.chip_gain_bonus_gain}
        }
    end,
    config = {
        extra = {
            chips = 4,
            chip_gain_bonus = 1,
            chip_gain_bonus_gain = 1 --what a mouthful
        }
    },
    atlas = "jokers_atlas",
    pos = {x=5,y=HODGE.atlas_y.joke[1]},
    soul_pos = {x=5,y=HODGE.atlas_y.soul[3]},
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    calculate = function(self,card,context)
        if context.joker_main and not context.blueprint then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.chip_gain_bonus = card.ability.extra.chip_gain_bonus + card.ability.extra.chip_gain_bonus_gain
            return {
                message = "Vest Up!"
            }
        end
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','joke')
    end
}