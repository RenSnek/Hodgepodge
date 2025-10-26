SMODS.Enhancement {
    key = "waterdamage",
    -- loc_txt = {
    --     label = "Water Damaged",
    --     name = "Water Damaged",
    --     text = {
    --         "{C:chips}+#1#{} bonus chips",
    --         "{C:green}#2#%{} chance to",
    --         "destroy card",
    --         "Values increase when scored"
    --     }
    -- },
    loc_vars = function(self,info_queue,card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator_neg, card.ability.extra.odds, 'waterdamaged')
        return {
            -- "{C:chips}+#1#{} bonus chips",
            -- "{C:green}#2# in #3#{} chance to",
            -- "destroy card",
            -- "{C:chips,s:0.9}+#4#{s:0.9} and {C:green,s:0.9}+#5# in #3#{s:0.9} when scored{}",
            vars = {
                card.ability.extra.scaling_chips,
                numerator,
                denominator,
                card.ability.extra.chip_gain,
                card.ability.extra.numerator_gain_neg
            }
        }
    end,
    atlas = "enhancements_atlas",
    pos = {x=2,y=0},
    config = {
        extra = {
            scaling_chips = 0,
            odds = 20,
            numerator_neg = 0,
            numerator_gain_neg = 1, --neg prefix prevents value manip
            chip_gain = 10
        }
    },
    calculate = function(self,card,context)
        if context.main_scoring and context.cardarea == G.play then
            card.ability.extra.scaling_chips = card.ability.extra.scaling_chips + card.ability.extra.chip_gain
            card.ability.extra.numerator_neg = card.ability.extra.numerator_neg + card.ability.extra.numerator_gain_neg
            return {
                chips = card.ability.extra.scaling_chips
            }
        end

        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card then
            if SMODS.pseudorandom_probability(card, 'waterdamaged', card.ability.extra.numerator_neg, card.ability.extra.odds, 'waterdamaged') then
                return {
                    message = "Ripped!",
                    remove = true
                }
            end
        end
    end
}