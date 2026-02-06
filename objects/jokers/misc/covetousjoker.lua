SMODS.Joker {
    key = "covetousjoker",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.card_mult
            }
        }
    end,
    config = {
        extra = {
            card_mult = 3
        }
    },
    atlas = "jokers_atlas",
    pos = {x=0,y=HODGE.atlas_y.misc[1]},
    rarity = 1,
    cost = 5,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.base.suit == "hodge_ladders" then
                return { mult = card.ability.extra.card_mult, message_card = context.other_card }
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