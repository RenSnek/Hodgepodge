if FusionJokers then

    SMODS.Joker {
        key = "bluestopsign",
        loc_vars = function (self,info_queue,card)
            return {
                vars = {card.ability.extra.rank,card.ability.extra.perma_x_chips}
            }
        end,
        config = {
            extra = {
                perma_x_chips = 0.8,
                rank = "8"
            }
        },
        atlas = "jokers_atlas",
        pos = {x=13,y=HODGE.atlas_y.crossmod[1]},
        rarity = "fuse_fusion",
        cost = 18,
        calculate = function(self,card,context)
            if context.individual and context.cardarea == G.play then
                if context.other_card.base.value == card.ability.extra.rank then
                    context.other_card.ability.perma_x_chips = context.other_card.ability.perma_x_chips + card.ability.extra.perma_x_chips
                    return {
                        card = context.other_card,
                        message = "blue",
                        colour = G.C.CHIPS
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
            { name = "j_hodge_stopsign" },
            { name = "j_hodge_bluelatro" }
        },
        result_joker = "j_hodge_bluestopsign",
        cost = 18
    }
    
else
    HODGE.fake_locked_joker("bluestopsign","fusionjokers")
end