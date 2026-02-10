SMODS.Joker {
    key = "jade",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.numerator_gain,
                card.ability.extra.numerator_static
            }
        }
    end,
    config = {
        extra = {
            numerator_gain = 0.5,
            numerator_static = 0
        }
    },
    atlas = "jokers_atlas",
    pos = {x=3,y=HODGE.atlas_y.misc[2]},
    rarity = 2,
    cost = 7,
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
        if context.mod_probability then
            return {
                numerator = context.numerator + card.ability.extra.numerator_static
            }
        end
    end,
    blueprint_compat = true,
    in_pool = function(self,args)
        for k,card in ipairs(G.playing_cards) do
            if card:is_suit("hodge_snake") then
                return true
            end
        end
        return false
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','misc')
    end
}