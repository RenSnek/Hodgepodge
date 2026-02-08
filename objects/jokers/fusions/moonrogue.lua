if FusionJokers then

    SMODS.Joker {
        key = "moonrogue",
        loc_vars = function (self,info_queue,card)
            return {
                vars = {
                    card.ability.extra.balance * 100,
                    card.ability.extra.balance_gain * 100
                }
            }
        end,
        config = {
            extra = {
                balance = 0.1,
                balance_gain = 0.05
            }
        },
        atlas = "jokers_atlas",
        pos = {x=1,y=HODGE.atlas_y.crossmod[1]},
        rarity = "fuse_fusion",
        cost = 12,
        calculate = function(self,card,context)
            if context.individual and context.cardarea == G.play then
                if context.other_card.base.suit == "hodge_moons" then
                    return {
                        hodge_partial_balance = card.ability.extra.balance
                    }
                end
            elseif context.using_consumeable and context.consumeable.ability.set == "Spectral" then
                if card.ability.extra.balance < 1 then -- Anything higher than 1 is essentially going backwards - 2 is the same as 0
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "balance",
                        scalar_value = "balance_gain"
                    })
                end
            end
        end,
        blueprint_compat = true,
        set_badges = function(self,card,badges)
            badges[#badges+1] = HODGE.badge('category','mlp')
        end
    }

    FusionJokers.fusions:register_fusion{
        jokers = {
            { name = "j_hodge_nightmarenight" },
            { name = "j_hodge_moonstone" }
        },
        result_joker = "j_hodge_moonrogue",
        cost = 12
    }
    
else
    HODGE.fake_locked_joker("moonrogue","fusionjokers")
end