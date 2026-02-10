SMODS.Joker {
    key = "missingno",
    -- loc_txt = {
    --     name = "MissingNo.",
    --     text = {
    --         -- "{C:dark_edition}+1{} Joker Slot",
    --         "On blind selected:",
    --         "Creates a {C:dark_edition}Negative{} copy of {C:attention}5th{} Joker",
    --         "{C:green}#1#%{} to become {C:attention}Bad EGG{} instead",
    --         "Chance doubles per copy owned",
    --         "{C:inactive}(#2#){}"
    --     }
    -- },
    loc_vars = function (self,info_queue,card)
        if G.jokers then
            if G.jokers.cards[5] then
                if G.jokers.cards[5].ability.name == "j_hodge_missingno" then
                    return {
                        vars = {
                            card.ability.extra.base_chance*100,
                            "What did I just say?"
                        }
                    }
                else
                    local selected_card = G.jokers.cards[5]
                    local chance = card.ability.extra.base_chance
                    for _, c in ipairs(G.jokers.cards) do
                        if c.ability.name == selected_card.ability.name and c ~= selected_card then
                            chance = chance * 2
                        end
                    end
                    return {
                        vars = {
                            card.ability.extra.base_chance*100,
                            "Currently "..(chance*100).."%"
                        }
                    }
                end
            else
                return {
                    vars = {
                        card.ability.extra.base_chance*100,
                        "No joker in 5th slot!"
                    }
                }
            end
        end
        return {
            vars = {
                card.ability.extra.base_chance*100,
                "Currently "..(card.ability.extra.base_chance*100).."%"
            }
        }
    end,
    config = {
        extra = {
            base_chance = 0.02
        }
    },
    atlas = "jokers_atlas",
    pos = {x=6,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=6,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.setting_blind and not context.blueprint then
            if G.jokers.cards[5] and G.jokers.cards[5].ability.name ~= "j_hodge_missingno" then
                local selected_card = G.jokers.cards[5]
                -- local all_copies = {}
                local chance = card.ability.extra.base_chance
                for _, c in ipairs(G.jokers.cards) do
                    if c.ability.name == selected_card.ability.name then
                        -- table.insert(all_copies,c)
                        if c ~= selected_card then
                            chance = chance * 2
                        end
                    end
                end
                if pseudorandom("missingno") < chance then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        card:flip()
                        play_sound('card1')
                        card:juice_up(0.3,0.3)
                        return true end }))
                    delay(0.2)
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                        card:set_ability(G.P_CENTERS["j_hodge_badegg"])
                        -- card.sell_cost = -256
                        card:flip()
                        play_sound('card1')
                        card:juice_up(0.3,0.3)
                        return true end }))
                else
                    G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
                        local new_card = copy_card(selected_card, nil, nil, nil, true)
                        new_card:start_materialize()
                        new_card:add_to_deck()
                        new_card:set_edition({negative = true}, true)
                        G.jokers:emplace(new_card)
                        return true end
                    })) 
                end
            end
        end
    end,
    blueprint_compat = false,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','pokemon')
    end
}
