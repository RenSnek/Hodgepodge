SMODS.Back {
    name = "Friendship Deck",
    key = "friendship",
    atlas = "decks_atlas",
    pos = {x=4,y=0},
    config = {},
    -- loc_txt = {
    --     name = "Friendship Deck",
    --     text = {
    --         "Includes {C:hodge_suns}Sun{} and {C:hodge_moons}Moon{} suits",
    --         "Includes 1 of each", "{C:attention}Element of Harmony{}"
    --     }
    -- },
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                local card_indices = {}
                for k,v in ipairs(G.playing_cards) do
                    table.insert(card_indices,k)
                end
                while #card_indices > 6 do
                    table.remove(card_indices,pseudorandom("friendship_deck",1,#card_indices))
                end
                G.playing_cards[card_indices[1]]:set_seal("hodge_loyalty")
                G.playing_cards[card_indices[2]]:set_seal("hodge_magic")
                G.playing_cards[card_indices[3]]:set_seal("hodge_kindness")
                G.playing_cards[card_indices[4]]:set_seal("hodge_honesty")
                G.playing_cards[card_indices[5]]:set_seal("hodge_generosity")
                G.playing_cards[card_indices[6]]:set_seal("hodge_laughter")
                return true
            end
        }))
    end
}

if CardSleeves then
    CardSleeves.Sleeve {
        key = "friendship",
        atlas = "sleeves_atlas",
        pos = {x=4,y=0},
        loc_vars = function(self)
            local key, vars
            if self.get_current_deck_key() == "b_hodge_friendship" then
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
            if self.get_current_deck_key() == "b_hodge_friendship" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for k,v in pairs(G.playing_cards) do
                            if (v.base.suit == 'hodge_suns' or v.base.suit == 'hodge_moons') then
                                v:set_seal(pseudorandom_element(HODGE.elements_of_harmony,"friendship_sleeve"))
                            end
                        end
                        return true
                    end
                }))
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card_indices = {}
                        for k,v in ipairs(G.playing_cards) do
                            table.insert(card_indices,k)
                        end
                        while #card_indices > 6 do
                            table.remove(card_indices,pseudorandom("friendship_deck",1,#card_indices))
                        end
                        G.playing_cards[card_indices[1]]:set_seal("hodge_loyalty")
                        G.playing_cards[card_indices[2]]:set_seal("hodge_magic")
                        G.playing_cards[card_indices[3]]:set_seal("hodge_kindness")
                        G.playing_cards[card_indices[4]]:set_seal("hodge_honesty")
                        G.playing_cards[card_indices[5]]:set_seal("hodge_generosity")
                        G.playing_cards[card_indices[6]]:set_seal("hodge_laughter")
                        return true
                    end
                }))
            end
        end
    }
end