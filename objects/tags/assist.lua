SMODS.Tag {
    key = "assist",
    atlas = "tags_atlas",
    pos = {x=0,y=0},
    apply = function(self,tag,context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true

            tag:yep("+", G.C.PURPLE, function()
                local legendaries = get_current_pool("Joker",nil, true)

                local pool = {}

                for k,v in ipairs(legendaries) do
                    if v ~= "UNAVAILABLE" and G.P_CENTERS[v].perishable_compat ~= false then
                        table.insert(pool,v)
                    end
                end

                local selected_joker = "j_joker"
                if #pool > 0 then
                    selected_joker = pseudorandom_element(pool, pseudoseed("assist"))
                end

                SMODS.add_card {
                    key = selected_joker,
                    stickers = {"perishable"},
                    force_stickers = true,
                    key_append = "hodge_assist"
                }
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}