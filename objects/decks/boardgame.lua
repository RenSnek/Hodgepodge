SMODS.Back {
    name = "Board Game Deck",
    key = "boardgame",
    atlas = "decks_atlas",
    pos = {x=3,y=0},
    config = {},
    -- loc_txt = {
    --     name = "Snake Deck",
    --     text = {
    --         "Includes cards with","the Snake suit"
    --     }
    -- },
    apply = function()
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
        G.E_MANAGER:add_event(Event({
            func = function() 
                local card = create_card('Joker', G.jokers, nil, 0, nil, nil, "j_oops", "boardgame")
                card:add_to_deck()
                G.jokers:emplace(card)
                card:start_materialize()
                G.GAME.joker_buffer = 0
                return true
            end}))   
    end
}

if CardSleeves then
    CardSleeves.Sleeve {
        key = "boardgame",
        atlas = "sleeves_atlas",
        pos = {x=3,y=0},
        loc_vars = function(self)
            local key, vars
            if self.get_current_deck_key() == "b_hodge_boardgame" then
                key = self.key .. "_alt"
                --variable changes here
                self.config = {alt = true}
                vars = {}
            else
                key = self.key
                --variable changes here
                self.config = {alt = false}
                vars = {}
            end
            return {key = key, vars = vars}
        end,
        config = {alt = false},
        apply = function(self,sleeve)
            if self.get_current_deck_key() == "b_hodge_boardgame" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for k,v in pairs(G.playing_cards) do
                            if (v.base.suit == 'Clubs' or v.base.suit == 'Spades') and pseudorandom('boardgame_sleeve') <= 0.25 then
                                v:change_suit('hodge_snake')
                            end
                            if (v.base.suit == 'Diamonds' or v.base.suit == 'Hearts') and pseudorandom('boardgame_sleeve') <= 0.25 then
                                v:change_suit('hodge_snake')
                            end
                        end
                        return true
                    end
                }))
            else
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = create_card('Joker', G.jokers, nil, 0, nil, nil, "j_oops", "boardgame")
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        G.GAME.joker_buffer = 0
                        return true
                    end}))   
            end
        end
    }
end