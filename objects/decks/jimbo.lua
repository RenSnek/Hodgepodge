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