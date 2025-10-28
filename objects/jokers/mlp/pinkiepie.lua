SMODS.Joker {
    key = "pinkiepie",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
            }
        }
    end,
    config = {
    },
    atlas = "jokers_atlas",
    pos = {x=7,y=HODGE.atlas_y.mlp[1]},
    rarity = 2,
    cost = 7,
    calculate = function(self,card,context)
        if context.repetition and context.cardarea == G.play and HODGE.table_contains(HODGE.elements_of_harmony,context.other_card.seal) then
            return {
                repetitions = 1
            }
        end
    end,
    blueprint_compat = true,
    in_pool = function(self,args)
        for k,card in ipairs(G.playing_cards) do
            if card.seal == "hodge_laughter" then
                return true
            end
        end
        return false
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}