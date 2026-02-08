if FusionJokers then

    SMODS.Joker {
        key = "cheesepie",
        loc_vars = function (self,info_queue,card)
            return {
                vars = {
                    card.ability.extra.card_xmult,
                }
            }
        end,
        config = {
            extra = {
                card_xmult = 2,
                triggered_cards = {}
            }
        },
        atlas = "jokers_atlas",
        pos = {x=12,y=HODGE.atlas_y.crossmod[1]},
        rarity = "fuse_fusion",
        cost = 12,
        calculate = function(self,card,context)
            if context.repetition then
                return {
                    repetitions = 1
                }
            end
            if context.before and context.cardarea == G.jokers and not context.blueprint then
                card.ability.extra.triggered_cards = {}
            end
            if context.individual and context.cardarea == G.play and not context.blueprint then
                if HODGE.table_contains(card.ability.extra.triggered_cards, context.other_card) then
                    --retriggering
                    return {
                        xmult = card.ability.extra.card_xmult
                    }
                else
                    --first trigger
                    card.ability.extra.triggered_cards[#card.ability.extra.triggered_cards+1] = context.other_card
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
            { name = "j_hodge_pinkiepie" },
            { name = "j_hodge_cheesesandwich" }
        },
        result_joker = "j_hodge_cheesepie",
        cost = 12
    }
    
else
    HODGE.fake_locked_joker("cheesepie","fusionjokers")
end