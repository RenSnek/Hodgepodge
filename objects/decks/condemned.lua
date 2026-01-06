SMODS.Back {
    name = "Condemned Deck",
    key = "condemned",
    atlas = "decks_atlas",
    pos = {x=2,y=0},
    config = {hodge_big = true},
    -- loc_txt = {
    --     name = "Condemned Deck",
    --     text = {
    --         "Random cards are missing",
    --         "Random cards are {C:attention,T:m_hodge_asbestos}Asbestos{}",
    --         "Random cards are {C:attention,T:m_hodge_waterdamage}Water Damaged{}"
    --     }
    -- },
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.playing_cards, 1, -1 do
                    local rand = math.random()
                    if rand < 0.2 then
                        G.playing_cards[i]:remove()
                    elseif rand < 0.35 then
                        G.playing_cards[i]:set_ability(G.P_CENTERS.m_hodge_asbestos)
                    elseif rand < 0.6 then
                        G.playing_cards[i]:set_ability(G.P_CENTERS.m_hodge_waterdamage)
                    end
                end
                return true
            end
        }))
    end
}

if CardSleeves then
    CardSleeves.Sleeve {
        key = "condemned",
        atlas = "sleeves_atlas",
        pos = {x=2,y=0},
        loc_vars = function(self)
            local key, vars
            if self.get_current_deck_key() == "b_hodge_condemned" then
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
            if self.get_current_deck_key() == "b_hodge_condemned" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card = create_card('Joker', G.jokers, nil, 0, nil, nil, "j_hodge_shooketh", "condemned")
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for i = #G.playing_cards, 1, -1 do
                            local rand = math.random()
                            if rand < 0.2 then
                                G.playing_cards[i]:remove()
                            elseif rand < 0.35 then
                                G.playing_cards[i]:set_ability(G.P_CENTERS.m_hodge_asbestos)
                            elseif rand < 0.6 then
                                G.playing_cards[i]:set_ability(G.P_CENTERS.m_hodge_waterdamage)
                            end
                        end
                        return true
                    end
                }))
            end
        end,
    }
end