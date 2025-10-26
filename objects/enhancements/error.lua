SMODS.Enhancement {
    key = "error",
    loc_vars = function(self,info_queue,card)
        return {
            vars = {
                card.ability.extra.strength * 100
            }
        }
    end,
    atlas = "enhancements_atlas",
    pos = {x=3,y=0},
    config = {
        extra = {
            strength = 0.05
        }
    },
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    calculate = function(self,card,context)
        if context.before and context.cardarea == G.play then
            local error_cards = 0
            local self_index = 0
            for k,scoring_card in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(scoring_card,'m_hodge_error') then
                    error_cards = error_cards + 1
                    if scoring_card == card then
                        self_index = k
                    end
                end
            end
            local strength_boost = (card.ability.extra.strength * error_cards)
            print(self_index,strength_boost)
            for k,joker in ipairs(G.jokers.cards) do
                Blockbuster.manipulate_value(joker,"hodge_error",strength_boost,nil,true)
                print(joker:get_multiplier_by_source(joker, "hodge_error"))
            end
        end
        if context.after then
            local self_index = 0
            for k,scoring_card in ipairs(context.scoring_hand) do
                if scoring_card == card then
                    self_index = k
                end
            end
            for k,joker in ipairs(G.jokers.cards) do
                Blockbuster.manipulate_value(joker,"hodge_error",1)
            end
        end
    end
}