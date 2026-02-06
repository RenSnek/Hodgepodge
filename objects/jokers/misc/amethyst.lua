SMODS.Joker {
    key = "amethyst",
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
            odds = 10
        }
    },
    atlas = "jokers_atlas",
    pos = {x=0,y=HODGE.atlas_y.misc[1]},
    rarity = 2,
    cost = 7,
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
    in_pool = function(self,args)
        for k,card in ipairs(G.playing_cards) do
            if card:is_suit("hodge_ladders") then
                return true
            end
        end
        return false
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','misc')
    end
}