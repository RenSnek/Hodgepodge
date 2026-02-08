if FusionJokers then

    SMODS.Joker {
        key = "suncleric",
        loc_vars = function (self,info_queue,card)
            return {
                vars = {
                    card.ability.extra.hand_level,
                    card.ability.extra.mult_per_level
                }
            }
        end,
        config = {
            extra = {
                hand_level = 0.1,
                mult_per_level = 2
                -- x_numerator_gain = 1,
            }
        },
        atlas = "jokers_atlas",
        pos = {x=0,y=HODGE.atlas_y.crossmod[1]},
        rarity = "fuse_fusion",
        cost = 12,
        calculate = function(self,card,context)
            if context.individual and context.cardarea == G.play then
                if context.other_card.base.suit == "hodge_suns" then
                    SMODS.upgrade_poker_hands({hands = context.scoring_name, level_up = 0.1, from = card})
                    return {
                        mult = math.floor(G.GAME.hands[context.scoring_name].level)*card.ability.extra.mult_per_level
                    }
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
            { name = "j_hodge_summersun" },
            { name = "j_hodge_amber" }
        },
        result_joker = "j_hodge_suncleric",
        cost = 12
    }
    
else
    HODGE.fake_locked_joker("suncleric","fusionjokers")
end