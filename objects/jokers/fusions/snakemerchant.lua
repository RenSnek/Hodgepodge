if FusionJokers then

    SMODS.Joker {
        key = "snakemerchant",
        loc_vars = function (self,info_queue,card)
            return {
                vars = {
                    card.ability.extra.numerator_gain,
                    card.ability.extra.numerator_static,
                    card.ability.extra.retriggers
                }
            }
        end,
        config = {
            extra = {
                numerator_gain = 0.5,
                numerator_static = 0,
                retriggers = 0
            }
        },
        atlas = "jokers_atlas",
        pos = {x=3,y=HODGE.atlas_y.crossmod[1]},
        rarity = "fuse_fusion",
        cost = 12,
        calculate = function(self,card,context)
            if context.before then
                card.ability.extra.numerator_static = 0
            end
            if context.individual and context.cardarea == G.play and not context.blueprint then
                if context.other_card.base.suit == "hodge_snake" then
                    card.ability.extra.numerator_static = card.ability.extra.numerator_static + card.ability.extra.numerator_gain
                    return {
                        message = "Upgrade!",
                        message_card = card
                    }
                end
            end
            if context.repetition and context.cardarea == G.play then
                return {
                    repetitions = card.ability.extra.retriggers
                }
            end
            if context.mod_probability then
                return {
                    numerator = context.numerator + card.ability.extra.numerator_static
                }
            end
            if context.pseudorandom_result and context.result then
                card.ability.extra.retriggers = card.ability.extra.retriggers + 1
            end
            if context.end_of_round then
                card.ability.extra.retriggers = 0
            end
        end,
        blueprint_compat = true,
        set_badges = function(self,card,badges)
            badges[#badges+1] = HODGE.badge('category','misc')
        end
    }

    FusionJokers.fusions:register_fusion{
        jokers = {
            { name = "j_hodge_deceitfuljoker" },
            { name = "j_hodge_jade" }
        },
        result_joker = "j_hodge_snakemerchant",
        cost = 12
    }
    
else
    HODGE.fake_locked_joker("snakemerchant","fusionjokers")
end