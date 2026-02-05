if FusionJokers then

    SMODS.Joker {
        key = "immoralimmortal",
        loc_vars = function (self,info_queue,card)
            return {
                vars = {
                    card.ability.extra.xmult,
                    card.ability.extra.xmult_gain
                }
            }
        end,
        config = {
            extra = {
                xmult = 1,
                xmult_gain = 1
            }
        },
        atlas = "jokers_atlas",
        pos = {x=0,y=HODGE.atlas_y.misc[1]},
        rarity = "fuse_fusion",
        cost = 32,
        calculate = function(self,card,context)
            if context.remove_playing_cards then
                -- card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.xmult_gain * #context.removed)
                for _,_ in ipairs(context.removed) do
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "xmult_gain"
                    })
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
        blueprint_compat = true,
        set_badges = function(self,card,badges)
            badges[#badges+1] = HODGE.badge('category','mlp')
        end
    }

    FusionJokers.fusions:register_fusion{
        jokers = {
            { name = "j_hodge_fluttershy" },
            { name = "j_vampire" }
        },
        result_joker = "j_hodge_flutterbat",
        cost = 20
    }
    FusionJokers.fusions:register_fusion{
        jokers = {
            { name = "j_hodge_flutterbat" },
            { name = "j_hodge_twilightsparkle" }
        },
        result_joker = "j_hodge_immoralimmortal",
        cost = 12
    }
    FusionJokers.fusions:register_fusion{
        jokers = {
            { name = "j_hodge_twishy" },
            { name = "j_vampire" }
        },
        result_joker = "j_hodge_immoralimmortal",
        cost = 20
    }
    
else
    HODGE.fake_locked_joker("immoralimmortal","fusionjokers")
end