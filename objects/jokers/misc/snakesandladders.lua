SMODS.Joker {
    key = "snakesandladders",
    loc_vars = function (self,info_queue,card)
        local numerator, denominator = SMODS.get_probability_vars(card,card.ability.extra.numerator,card.ability.extra.odds,'snakesandladders')
        return {
            vars = {
                numerator,
                denominator,
                card.ability.extra.rank_change
            }
        }
    end,
    config = {
        extra = {
            rank_change = 1,
            numerator = 1,
            odds = 2
        }
    },
    atlas = "jokers_atlas",
    pos = {x=0,y=HODGE.atlas_y.misc[1]},
    rarity = 2,
    cost = 6,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            local rank_change = ({
                hodge_ladders=card.ability.extra.rank_change,
                hodge_snake=-card.ability.extra.rank_change
            })[context.other_card.base.suit]

            if rank_change and SMODS.pseudorandom_probability(card,'snakesandladders',card.ability.extra.numerator,card.ability.extra.odds,'snakesandladders') then
                local other_card = context.other_card
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        play_sound('tarot1')
                        card:juice_up(0.3,0.5)
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        other_card:flip()
                        play_sound('card1')
                        other_card:juice_up(0.3,0.3)
                        return true
                    end
                }))
                delay(0.1)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        SMODS.modify_rank(other_card, rank_change)
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        other_card:flip()
                        play_sound('tarot2')
                        other_card:juice_up(0.3,0.5)
                        return true
                    end
                }))
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