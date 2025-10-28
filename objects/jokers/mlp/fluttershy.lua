SMODS.Joker {
    key = "fluttershy",
    loc_vars = function (self,info_queue,card)
        local total_mult = 0
        if G.playing_cards then
            for k,currentCard in pairs(G.playing_cards) do
                if HODGE.table_contains(HODGE.elements_of_harmony,currentCard.seal) then
                    total_mult = total_mult + card.ability.extra.mult_per_seal
                end
            end
        else
            total_mult = 0
        end
        return {
            vars = {
                card.ability.extra.mult_per_seal,
                total_mult
            }
        }
    end,
    config = {
        extra = {
            mult_per_seal = 1
        }
    },
    atlas = "jokers_atlas",
    pos = {x=9,y=HODGE.atlas_y.mlp[1]},
    rarity = 2,
    cost = 7,
    calculate = function(self,card,context)
        if context.joker_main then
            local total_mult = 0
            for k,currentCard in pairs(G.playing_cards) do
                if HODGE.table_contains(HODGE.elements_of_harmony,currentCard.seal) then
                    total_mult = total_mult + card.ability.extra.mult_per_seal
                end
            end
            return {mult = total_mult}
        end
    end,
    blueprint_compat = true,
    in_pool = function(self,args)
        for k,card in ipairs(G.playing_cards) do
            if card.seal == "hodge_kindness" then
                return true
            end
        end
        return false
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}