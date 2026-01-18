SMODS.Joker {
    key = "littlemissrarity",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.x_mult
            }
        }
    end,
    config = {
        x_mult = 1,
        extra = {
            value_mult = 0.2
        }
    },
    atlas = "jokers_atlas",
    pos = {x=13,y=HODGE.atlas_y.mlp[1]},
    rarity = 3,
    cost = 7,
    calculate = function(self,card,context)
        if context.selling_card and context.cardarea == G.jokers and not context.selling_self then
            if context.card ~= card then
                card.ability.x_mult = card.ability.x_mult + (context.card.sell_cost * card.ability.extra.value_mult)
                return {
                    dollars = -context.card.sell_cost,
                    message = "+"..(context.card.sell_cost * card.ability.extra.value_mult).."X"
                }
            end
        end
    end,
    blueprint_compat = true,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}