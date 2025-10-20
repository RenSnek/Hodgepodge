SMODS.Shader {
    key = "parasite",
    path = "parasite.fs"
}

SMODS.Sound {
    key = "spawn_parasite",
    path = "sfx_spawn_parasite.ogg"
}
SMODS.Sound {
    key = "parasite_degrade",
    path = "sfx_parasite_degrade.ogg"
}
SMODS.Sound {
    key = "parasite_infect",
    path = "sfx_parasite_infect.ogg"
}

SMODS.Edition {
    key = "parasite",
    shader = "parasite",
    -- loc_txt = {
    --     label = "Parasite",
    --     name = "Parasite",
    --     text = {
    --         "{X:mult,C:white}X#1#{} Mult",
    --         "{X:mult,C:white}-X#2#{} every round",
    --         "{s:0.8}At {s:0.8,X:mult,C:white}X#3#{s:0.8}, destroy this joker",
    --         "{s:0.8}and apply {s:0.8,C:attention}Parasite{s:0.8} to{}",
    --         "{s:0.8}an editionless joker{}"
    --     }
    -- },
    loc_vars = function(self, info_queue, card)
        --info_queue[#info_queue+1] = G.P_CENTERS["e_hodge_parasite"]
        local vals = self.config
        if (card.edition and card.edition.extra) then
            vals = card.edition
        end
        return {vars = {vals.x_mult,vals.extra.decrease,vals.extra.floor}}
    end,
    config = {
        x_mult = 3,
        extra = {
            decrease = 0.2,
            floor = 1,
            has_scored = false
        }
    },
    sound = {sound = "hodge_spawn_parasite", per = 1, vol = 0.6},
    in_shop = true,
    weight = 8,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    extra_cost = 4,
    apply_to_float = false,
    disable_base_shader = false,
    calculate = function(self, card, context)
        local area = (context.cardarea == G.play and "G.play") or (context.cardarea == G.hand and "G.hand") or (context.cardarea == G.jokers and "G.jokers") or "Unchecked"
        if ((context.main_scoring and context.cardarea == G.play) or context.post_joker) then
            card.edition.extra.has_scored = true
            return {x_mult = card.edition.x_mult}
        end

        if context.destroy_card and context.destroying_card == card and card.edition.extra.has_scored then
            card.edition.x_mult = card.edition.x_mult - card.edition.extra.decrease
            if card.edition.x_mult <= card.edition.extra.floor then
                return {
                    message = "Drained!",
                    remove=true,
                    func = function()
                        local eligible_editionless_cards = {}
                        for k, v in pairs(G.hand.cards) do
                            if v.ability.set == 'Default' and (not v.edition) then
                                table.insert(eligible_editionless_cards, v)
                            end
                        end
                        if HODGE.table_true_size(eligible_editionless_cards) > 0 then 
                            local over = false
                            local temp_pool = eligible_editionless_cards or {}
                            local eligible_card = pseudorandom_element(temp_pool, pseudoseed("parasite"))
                            if eligible_card then
                                eligible_card:set_edition({["hodge_parasite"] = true}, true)
                            end
                            check_for_unlock({type = 'have_edition'})
                        end
                        play_sound("hodge_parasite_infect", 1, 0.6)
                        -- G.hand:remove_card(card)
                        -- card:remove()
                        -- card = nil
                        return true
                    end
                }
            else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        play_sound("hodge_parasite_degrade", 1, 0.6)
                        return true;
                    end
                }))
            end
            return {message = "-"..card.edition.extra.decrease.."X"}
        end

        if context.end_of_round and context.main_eval and context.cardarea == G.jokers and card.edition.extra.has_scored then
            -- print("end_of_round")
            card.edition.x_mult = card.edition.x_mult - card.edition.extra.decrease
            if card.edition.x_mult <= card.edition.extra.floor then
                local eligible_editionless_jokers = {}
                for k, v in pairs(G.jokers.cards) do
                    if v.ability.set == 'Joker' and (not v.edition) then
                        table.insert(eligible_editionless_jokers, v)
                    end
                end
                if HODGE.table_true_size(eligible_editionless_jokers) > 0 then 
                    local over = false
                    local temp_pool = eligible_editionless_jokers or {}
                    local eligible_card = pseudorandom_element(temp_pool, pseudoseed("parasite"))
                    if eligible_card then
                        eligible_card:set_edition({["hodge_parasite"] = true}, true)
                    end
                    check_for_unlock({type = 'have_edition'})
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        play_sound("hodge_parasite_infect", 1, 0.6)
                        return true;
                    end
                }))
                return {message = "Drained!"}
            else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        play_sound("hodge_parasite_degrade", 1, 0.6)
                        return true;
                    end
                }))
            end
            return {message = "-"..card.edition.extra.decrease.."X"}   
        end

        -- if ((context.main_scoring and context.cardarea == G.play) or context.post_joker) then
        --     print("main_scoring")
        --     card.edition.extra.has_scored = true
        --     return {x_mult = card.edition.x_mult}
        -- end

        -- if context.destroy_card and context.cardarea == G.play and card.edition.extra.has_scored then
        --     print("destroy_card")
        --     card.edition.x_mult = card.edition.x_mult - card.edition.extra.decrease
        --     if card.edition.x_mult <= card.edition.extra.floor then
                
        --         return {
        --             message = "Drained!",
        --             remove=true,
        --             func = function()
        --                 local eligible_editionless_cards = {}
        --                 for k, v in pairs(G.hand.cards) do
        --                     if v.ability.set == 'Default' and (not v.edition) then
        --                         table.insert(eligible_editionless_cards, v)
        --                     end
        --                 end
        --                 if HODGE.table_true_size(eligible_editionless_cards) > 0 then 
        --                     local over = false
        --                     local temp_pool = eligible_editionless_cards or {}
        --                     local eligible_card = pseudorandom_element(temp_pool, pseudoseed("parasite"))
        --                     eligible_card:set_edition({["hodge_parasite"] = true}, true)
        --                     check_for_unlock({type = 'have_edition'})
        --                 end
        --                 -- G.hand:remove_card(card)
        --                 -- card:remove()
        --                 -- card = nil
        --                 return true
        --             end
        --         }
        --     end
        --     return {message = "-"..card.edition.extra.decrease.."X"}   
        -- end

        -- if context.end_of_round and context.main_eval and context.cardarea == G.jokers and card.edition.extra.has_scored then
        --     print("end_of_round")
        --     card.edition.x_mult = card.edition.x_mult - card.edition.extra.decrease
        --     if card.edition.x_mult <= card.edition.extra.floor then
        --         local eligible_editionless_jokers = {}
        --         for k, v in pairs(G.jokers.cards) do
        --             if v.ability.set == 'Joker' and (not v.edition) then
        --                 table.insert(eligible_editionless_jokers, v)
        --             end
        --         end
        --         if HODGE.table_true_size(eligible_editionless_jokers) > 0 then 
        --             local over = false
        --             local temp_pool = eligible_editionless_jokers or {}
        --             local eligible_card = pseudorandom_element(temp_pool, pseudoseed("parasite"))
        --             eligible_card:set_edition({["hodge_parasite"] = true}, true)
        --             check_for_unlock({type = 'have_edition'})
        --         end
        --         G.E_MANAGER:add_event(Event({
        --             trigger = 'after',
        --             delay = 0.3,
        --             blockable = false,
        --             func = function()
        --                 G.jokers:remove_card(card)
        --                 card:remove()
        --                 card = nil
        --                 return true;
        --             end
        --         }))
        --         return {message = "Drained!"}
        --     end
        --     return {message = "-"..card.edition.extra.decrease.."X"}   
        -- end
    end
}