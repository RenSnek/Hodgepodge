SMODS.Joker {
    key = "cheesesandwich",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.card_xmult
            }
        }
    end,
    config = {
        extra = {
            card_xmult = 2,
            triggered_cards = {},
        }
    },
    atlas = "jokers_atlas",
    pos = {x=13,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=13,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.triggered_cards = {}
        end
        if context.individual and context.cardarea == G.play and HODGE.table_contains(HODGE.elements_of_harmony,context.other_card.seal) and not context.blueprint then
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
    blueprint_compat = false,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}
