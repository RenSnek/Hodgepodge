SMODS.Joker {
    key = "moonstone",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.balance * 100
            }
        }
    end,
    config = {
        extra = {
            balance = 0.10
        }
    },
    atlas = "jokers_atlas",
    pos = {x=4,y=HODGE.atlas_y.mlp[1]},
    rarity = 2,
    cost = 7,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.base.suit == "hodge_moons" then
                local balance_chips = ((1-card.ability.extra.balance)*hand_chips) + (card.ability.extra.balance*((hand_chips+mult)/2))
                local balance_mult = ((1-card.ability.extra.balance)*mult) + (card.ability.extra.balance*((hand_chips+mult)/2))
                
                local chips_diff = balance_chips - hand_chips 
                local mult_diff = balance_mult - mult
                
                return {
                    chips = chips_diff,
                    mult = mult_diff,
                    message = "Balance!",
                    colour = G.C.PURPLE,
                    remove_default_message = true
                }
            end
        end
    end,
    blueprint_compat = true,
    in_pool = function(self,args)
        for k,card in ipairs(G.playing_cards) do
            if card:is_suit("hodge_moons") then
                return true
            end
        end
        return false
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
        badges[#badges+1] = HODGE.badge('credit','pumpkin')
    end
}