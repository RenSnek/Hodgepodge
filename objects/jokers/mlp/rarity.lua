SMODS.Joker {
    key = "rarity",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.mult_gain
            }
        }
    end,
    config = {
        extra = {
            mult_gain = 1
        }
    },
    atlas = "jokers_atlas",
    pos = {x=6,y=HODGE.atlas_y.mlp[1]},
    rarity = 2,
    cost = 7,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if HODGE.table_contains(HODGE.elements_of_harmony,context.other_card.seal) then
                --print("stopsign hit")
                context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult_gain
                return {
                    card = context.other_card,
                    message = "Upgrade!"
                }
            end
        end
    end,
    blueprint_compat = true,
    in_pool = function(self,args)
        for k,card in ipairs(G.playing_cards) do
            if card.seal == "hodge_generosity" then
                return true
            end
        end
        return false
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}