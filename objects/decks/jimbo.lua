SMODS.Back {
    name = "Jimbo Deck",
    key = "jimbo",
    atlas = "decks_atlas",
    pos = {x=1,y=0},
    config = {},
    calculate = function(self,back,context)
        if context.initial_scoring_step then
            return {mult = 4}
        end
    end
}

if CardSleeves then
    CardSleeves.Sleeve {
        key = "jimbo",
        atlas = "sleeves_atlas",
        pos = {x=1,y=0},
        loc_vars = function(self)
            local key, vars
            if self.get_current_deck_key() == "b_hodge_jimbo" then
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
            if self.get_current_deck_key() == "b_hodge_jimbo" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        return true
                    end
                }))
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        return true
                    end
                }))
            end
        end,
        calculate = function(self,sleeve,context)
            if context.initial_scoring_step then
                if sleeve.config.alt then
                    return {xmult=4}
                else
                    return {mult=4}
                end
            end
        end
    }
end