SMODS.Joker {
    key = "blip",
    loc_vars = function (self,info_queue,card)
        info_queue[#info_queue+1] = G.P_CENTERS["c_"..card.ability.extra.consumable]
        return {
            vars = {
                -card.ability.extra.hand_size_loss,
                card.ability.extra.xmult_per_size,
                (G.hand and math.max((G.hand.config.card_limit-8)*card.ability.extra.xmult_per_size,0)+1) or 1
            }
        }
    end,
    config = {
        extra = {
            consumable = "hodge_crumb",
            xmult_per_size = 0.1,
            hand_size_loss = 1
        }
    },
    atlas = "jokers_atlas",
    pos = {x=2,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=2,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.before and not context.blueprint then
            G.hand:change_size(-card.ability.extra.hand_size_loss)
        end
        if context.end_of_round and context.cardarea == G.jokers then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({
                        key = "c_hodge_crumb",
                        edition = "e_negative"
                    })
                    return true
                end
            }))
        end
        if context.joker_main then
            return {
                xmult = math.max((G.hand.config.card_limit-8)*card.ability.extra.xmult_per_size,0)+1
            }
        end
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','misc')
    end
}

