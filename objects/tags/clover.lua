SMODS.Tag {
    key = "clover",
    atlas = "tags_atlas",
    pos = {x=4,y=0},
    apply = function(self,tag,context)
        -- print(context.type)
        if context.type == 'end_of_round' then --this is not the vanilla end_of_round context. tags use different contexts. i modded this one in. check the top of hodgepodge.lua
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true

            tag:yep("+", G.C.PURPLE, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true 
        end
    end
}