SMODS.Joker {
    key = "amber",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.hand_level
            }
        }
    end,
    config = {
        extra = {
            -- odds = 5,
            -- numerator = 1,
            -- hands_gain = 1
            hand_level = 0.1
        }
    },
    atlas = "jokers_atlas",
    pos = {x=3,y=HODGE.atlas_y.mlp[1]},
    rarity = 2,
    cost = 7,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.base.suit == "hodge_suns" then
                SMODS.upgrade_poker_hands({hands = context.scoring_name, level_up = 0.1, from = card})
            end
        end
    end,
    blueprint_compat = true,
    in_pool = function(self,args)
        for k,card in ipairs(G.playing_cards) do
            if card:is_suit("hodge_suns") then
                return true
            end
        end
        return false
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}