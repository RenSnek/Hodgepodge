SMODS.Joker {
    key = "flutterbat",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.xmult_gain,
                card.ability.extra.scaling_xmult
            }
        }
    end,
    config = {
        extra = {
            scaling_xmult = 1,
            xmult_gain = 0.25
        }
    },
    atlas = "jokers_atlas",
    pos = {x=12,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=12,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.before and not context.blueprint then
            local suits = {
                ["Hearts"] = "Spades",
                ["Diamonds"] = "Clubs",
                ["hodge_snake"] = "hodge_ladders",
                ["hodge_suns"] = "hodge_moons"
            }
            local light = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if suits[scored_card.base.suit] and not scored_card.debuff and not scored_card.hodge_inked then
                    light[#light+1] = scored_card
                    scored_card.hodge_inked = true
                    assert(SMODS.change_base(scored_card,suits[scored_card.base.suit]))
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            scored_card.hodge_inked = nil
                            return true
                        end
                    }))
                end
            end
            
            if #light > 0 then
                card.ability.extra.scaling_xmult = card.ability.extra.scaling_xmult + card.ability.extra.xmult_gain * #light
                return {
                    message = "+"..(card.ability.extra.xmult_gain * #light).."X",
                    colour = G.C.MULT
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.scaling_xmult
            }
        end
    end,
    blueprint_compat = true,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}
