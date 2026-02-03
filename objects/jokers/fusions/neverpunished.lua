if FusionJokers then

    SMODS.Joker {
        key = "neverpunished",
        loc_vars = function (self,info_queue,card)
            return {
                vars = {
                    card.ability.extra.x_numerator
                    -- card.ability.extra.x_numerator_gain
                }
            }
        end,
        config = {
            extra = {
                x_numerator = 1
                -- x_numerator_gain = 1,
            }
        },
        atlas = "jokers_atlas",
        pos = {x=0,y=HODGE.atlas_y.misc[1]},
        rarity = "fuse_fusion",
        cost = 12,
        calculate = function(self,card,context)
            if context.mod_probability then
                return {
                    numerator = context.numerator * card.ability.extra.x_numerator
                }
            end
            if context.pseudorandom_result then
                if context.result then
                    card.ability.extra.x_numerator = 1
                    return {
                        message = "Reset!",
                        color = G.C.GREEN
                    }
                else
                    card.ability.extra.x_numerator = card.ability.extra.x_numerator * 2
                    return {
                        message = "Upgrade!",
                        color = G.C.GREEN
                    }
                end
            end
        end,
        blueprint_compat = true,
        set_badges = function(self,card,badges)
            badges[#badges+1] = HODGE.badge('category','joke')
        end
    }

    FusionJokers.fusions:register_fusion{
        jokers = {
            { name = "j_oops" },
            { name = "j_hodge_biggamba" }
        },
        result_joker = "j_hodge_neverpunished",
        cost = 12
    }
    
else
    HODGE.fake_locked_joker("neverpunished","fusionjokers")
end