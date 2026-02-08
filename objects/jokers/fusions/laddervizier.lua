if FusionJokers then

    SMODS.Joker {
        key = "laddervizier",
        loc_vars = function (self,info_queue,card)
            local numerator, denominator = SMODS.get_probability_vars(card,card.ability.extra.numerator,card.ability.extra.odds,'amethyst')
            return {
                vars = {
                    numerator,
                    denominator
                }
            }
        end,
        config = {
            extra = {
                numerator = 1,
                odds = 8
            }
        },
        atlas = "jokers_atlas",
        pos = {x=4,y=HODGE.atlas_y.crossmod[1]},
        rarity = "fuse_fusion",
        cost = 12,
        calculate = function(self,card,context)
            if context.individual and context.cardarea == G.play then
                if context.other_card.base.suit == "hodge_ladders" and SMODS.pseudorandom_probability(card,'amethyst',card.ability.extra.numerator,card.ability.extra.odds,'amethyst') then
                    local editions = {"foil","holo","polychrome","negative"}
                    if (not context.other_card.edition) or (HODGE.table_contains(editions,context.other_card.edition.type) and context.other_card.edition.type ~= editions[#editions]) then
                        local next_edition = editions[1]
                        if context.other_card.edition then
                            for i,edition in ipairs(editions) do
                                if context.other_card.edition.type == edition then
                                    next_edition = editions[i+1]
                                end
                            end
                        end
                        local other_card = context.other_card
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                            other_card:set_edition({[next_edition] = true}, true)
                            other_card:juice_up(0.3, 0.3);
                            card:juice_up(0.3,0.3);
                            return true end
                        }))
                    end
                end
            end
        end,
        blueprint_compat = true,
        set_badges = function(self,card,badges)
            badges[#badges+1] = HODGE.badge('category','misc')
        end
    }

    FusionJokers.fusions:register_fusion{
        jokers = {
            { name = "j_hodge_covetousjoker" },
            { name = "j_hodge_amethyst" }
        },
        result_joker = "j_hodge_laddervizier",
        cost = 12
    }
    
else
    HODGE.fake_locked_joker("laddervizier","fusionjokers")
end