SMODS.Joker {
    key = "twilightsparkle",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
            }
        }
    end,
    config = {
    },
    atlas = "jokers_atlas",
    pos = {x=2,y=HODGE.atlas_y.mlp[1]},
    soul_pos = {x=2,y=HODGE.atlas_y.soul[4]},
    rarity = 2,
    cost = 7,
    calculate = function(self,card,context)
        if context.joker_main then
            
            local eligible_sealless_cards = {}
            for k, v in pairs(context.scoring_hand) do
                if v.ability.set == 'Default' and (not v.seal) then
                    table.insert(eligible_sealless_cards, v)
                end
            end
            if HODGE.table_true_size(eligible_sealless_cards) > 0 then 
                local over = false
                local temp_pool = eligible_sealless_cards or {}
                local eligible_card = pseudorandom_element(temp_pool, pseudoseed("twilightsparkle"))
                local selected_element = pseudorandom_element(HODGE.elements_of_harmony, pseudoseed("twilightsparkle"))
                eligible_card:set_seal(selected_element, nil, true) -- if you queue it the other jokers can still choose it as if it has no seal
                G.E_MANAGER:add_event(Event({func = function()
                    play_sound("tarot1")
                    card:juice_up(0.3, 0.5)
                    return true end}))
            end
        end
    end,
    blueprint_compat = true,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
        badges[#badges+1] = HODGE.badge('credit','jorse')
    end
}