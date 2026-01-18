SMODS.Joker {
    key = "applesleepexperiment",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.retriggers
            }
        }
    end,
    config = {
        extra = {
            retriggers = 3,
            retrigger_targets = {}
        }
    },
    atlas = "jokers_atlas",
    pos = {x=14,y=HODGE.atlas_y.mlp[1]},
    rarity = 3,
    cost = 7,
    calculate = function(self,card,context)
        if context.press_play then
            --print(context.full_hand)
            for k,playing_card in pairs(G.hand.highlighted) do
                --print(playing_card.debuff)
                if playing_card.debuff then
                    playing_card.hodge_unscored = true
                    playing_card:set_debuff(false)
                end
            end
        end
        if context.modify_scoring_hand and not context.blueprint then
            if not HODGE.table_contains(context.scoring_hand,context.other_card) then
                context.other_card.hodge_unscored = true
                return {
                    add_to_hand = true
                }
            else
                context.other_card.hodge_unscored = false
            end
        end
        if context.repetition and context.cardarea == G.play and context.other_card.hodge_unscored then
            return {
                repetitions = card.ability.extra.retriggers
            }
        end
    end,
    blueprint_compat = true,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}