SMODS.Joker {
    key = "runerigus",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
            }
        }
    end,
    config = {
    },
    atlas = "jokers_atlas",
    pos = {x=9,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=9,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.repetition and context.cardarea == G.play then
            local retriggers = 0
            for k,currentCard in pairs(G.hand.cards) do
                if SMODS.has_enhancement(currentCard, 'm_stone') then
                    retriggers = retriggers + 1
                end
            end
            if retriggers > 0 then
                return {
                    repetitions = retriggers
                }
            end
        end
    end,
    blueprint_compat = true,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','pokemon')
    end
}
