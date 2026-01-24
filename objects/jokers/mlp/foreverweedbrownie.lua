SMODS.Joker {
    key = "foreverweedbrownie",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
            }
        }
    end,
    config = {
        extra = {
            first_hand = true,
            edition = "polychrome"
        }
    },
    atlas = "jokers_atlas",
    pos = {x=14,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=14,y=HODGE.atlas_y.soul[4]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.setting_blind and not context.blueprint then
            SMODS.Stickers['eternal']:apply(card,true)
            card:juice_up()
            card.ability.extra.first_hand = true
        end
        if context.before and card.ability.extra.first_hand and not context.blueprint then
            card.ability.extra.first_hand = false

            local eligible_cards = {}
            for i,scoring_card in pairs(context.scoring_hand) do
                if not scoring_card.destroyed then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                        scoring_card:set_edition({[card.ability.extra.edition] = true}, true)
                        scoring_card:juice_up(0.3, 0.3);
                        card:juice_up(0.3,0.3);
                    return true end
                }))
                end
            end
        end

        if (context.starting_shop or context.reroll_shop) and card.ability.eternal and not context.blueprint then
            for _,shop_card in ipairs(G.shop_jokers.cards) do
                shop_card:set_edition({[card.ability.extra.edition] = true}, true)
            end
        end
    end,
    blueprint_compat = false,
    perishable_compat = false,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}
