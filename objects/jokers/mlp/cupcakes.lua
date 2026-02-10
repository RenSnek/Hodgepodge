SMODS.Joker {
    key = "cupcakes",
    -- loc_txt = {
    --     name = "Cupcakes",
    --     text = {
    --         "{X:mult,C:white}X#1#{} Mult, loses {X:mult,C:white}X#2#{} Mult",
    --         "per hand played",
    --         "Gains {X:mult,C:white}X#3#{} per scoring card",
    --         "with {C:attention}Element of Loyalty{} and",
    --         "destroys the card"
    --     }
    -- },
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.scaling_xmult,
                card.ability.extra.mult_loss,
                card.ability.extra.mult_gain
            }
        }
    end,
    config = {
        extra = {
            scaling_xmult = 2,
            mult_loss = 0.1,
            mult_gain = 0.5
        }
    },
    atlas = "jokers_atlas",
    pos = {x=11,y=HODGE.atlas_y.mlp[1]},
    soul_pos = {x=11,y=HODGE.atlas_y.soul[4]},
    rarity = 3,
    cost = 7,
    calculate = function(self,card,context)
        if context.final_scoring_step and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.scaling_xmult = card.ability.extra.scaling_xmult - card.ability.extra.mult_loss
            return {
                message = "-"..card.ability.extra.mult_loss.."X"
            }
        end
        if context.destroy_card and context.cardarea == G.play and context.destroy_card.seal == "hodge_loyalty" and not context.blueprint then
            card.ability.extra.scaling_xmult = card.ability.extra.scaling_xmult + card.ability.extra.mult_gain
            return {
                remove = true,
                message = "+"..card.ability.extra.mult_gain.."X",
                message_card = card
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.scaling_xmult
            }
        end
    end,
    blueprint_compat = true,
    in_pool = function(self,args)
        for k,card in ipairs(G.playing_cards) do
            if card.seal == "hodge_loyalty" then
                return true
            end
        end
        return false
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}