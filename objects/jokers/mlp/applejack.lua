SMODS.Joker {
    key = "applejack", 
    loc_vars = function (self,info_queue,card)
        local count = 52/2
        if G.playing_cards and G.deck then
            local elements = 0
            for k,currentCard in pairs(G.playing_cards) do
                if HODGE.table_contains(HODGE.elements_of_harmony,currentCard.seal) then
                    elements = elements + 1
                end
            end
            if elements > (G.deck.config.true_card_limit)/2 then
                count = elements
            else
                count = (G.deck.config.true_card_limit)/2
            end
        end
        return {
            vars = {
                count
            }
        }
    end,
    config = {
        extra = {
            mult_gain = 1
        }
    },
    atlas = "jokers_atlas",
    pos = {x=8,y=HODGE.atlas_y.mlp[1]},
    rarity = 2,
    cost = 7,
    calculate = function(self,card,context)
    end,
    blueprint_compat = false,
    in_pool = function(self,args)
        for k,card in ipairs(G.playing_cards) do
            if card.seal == "hodge_honesty" then
                return true
            end
        end
        return false
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
        badges[#badges+1] = HODGE.badge('credit','jorse')
    end
}

local cardAreaShuffle = CardArea.shuffle
function CardArea:shuffle(_seed)
    if self.config.type == "deck" and next(SMODS.find_card("j_hodge_applejack")) then
        --print("AJ Shuffle")
        local count = 0
        local elements = 0
        for k,currentCard in pairs(G.playing_cards) do
            if HODGE.table_contains(HODGE.elements_of_harmony,currentCard.seal) then
                elements = elements + 1
            end
        end
        if elements > #G.deck.cards/2 then
            count = #G.deck.cards - elements
        else
            count = #G.deck.cards/2
        end
        --print(count)
        HODGE.force_front_shuffle(self.cards, function(item) return HODGE.table_contains(HODGE.elements_of_harmony,item.seal) end, count, pseudoseed(_seed or 'shuffle'))
        self:set_ranks()
    else
        return cardAreaShuffle(self,_seed)
    end
end