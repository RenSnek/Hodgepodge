SMODS.Joker {
    key = "david",
    -- loc_txt = {
    --     name = "David",
    --     text = {
    --         "On blind selected:",
    --         "{C:green}90%{} to create Negative Ice Cream",
    --         "{C:green}10%{} to create Negative David",
    --         "If {C:attention}#1#{} scored, {C:attention}destroy{} this card",
    --         "{C:inactive,s:0.85}Rank chosen on Blind selected{}"
    --     }
    -- },
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                G.david_rank or "Ace"
            }
        }
    end,
    config = {
    },
    atlas = "jokers_atlas",
    pos = {x=1,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=1,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.setting_blind then
            if HODGE.david_last_set ~= G.GAME.round or not HODGE.david_rank then
                local ranks = {}
                for k,card in ipairs(G.playing_cards) do
                    if not HODGE.table_contains(ranks,card.base.value) then
                        table.insert(ranks,card.base.value)
                    end
                    G.david_last_set = G.GAME.round
                    G.david_rank = pseudorandom_element(ranks, pseudoseed("david"))
                end
            end

            local joker_id = "j_ice_cream"
            if pseudorandom("david") < 0.1 then
                joker_id = "j_hodge_david"
            end
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = create_card('Joker', G.jokers, nil, 0, nil, nil, joker_id, "david")
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:set_edition({["negative"] = true}, true)
                    card:start_materialize()
                    G.GAME.joker_buffer = 0
                    return true
                end}))   
            if joker_id == "j_ice_cream" then
                return {message = "I want an Ice Cream!"}
            else
                return {message = "I want another David!"}
            end
        end
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card.base.value == G.david_rank then
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card:start_dissolve(nil, nil, 1.6)
                return true end }))
                return {message = "AAAAAAAAA", message_card = card}
            end
        end
    end,
    blueprint_compat = true,
    add_to_deck = function(self,card,from_debuff)
        if not HODGE.david_rank then
            local ranks = {}
            for k,card in ipairs(G.playing_cards) do
                if not HODGE.table_contains(ranks,card.base.value) then
                    table.insert(ranks,card.base.value)
                end
                G.david_last_set = G.GAME.round
                G.david_rank = pseudorandom_element(ranks, pseudoseed("david"))
            end
        end
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','joke')
    end
}