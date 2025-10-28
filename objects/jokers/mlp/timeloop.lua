SMODS.Joker {
    key = "timeloop",
    -- loc_txt = {
    --     name = "Day 734",
    --     text = {
    --         "After {C:attention}Boss Blind{} is defeated,",
    --         "rewind to start of the Ante.",
    --         "{C:gold}Money{}, {C:attention}Jokers{}, {C:attention}Shops{}, etc. are",
    --         "included in the rewind.",
    --         "{C:inactive,s:0.9}#1#{}"
    --     }
    -- },
    loc_vars = function (self,info_queue,card)
        -- card.ability.extra.loop_started_ui = card.ability.extra.loop_started_ui or ""
        local loop_active_text = "ERROR: shits fucked idk"
        if card.ability.extra.loop_started then
            loop_active_text = "Loop active from ante "..card.ability.extra.loop_ante.."."
        else
            loop_active_text = "Waiting for new ante..."
        end
        return {
            vars = {
                loop_active_text,
                card.ability.extra.charges,
            },
            -- main_end = (card.area and card.area == G.jokers) and {
            --     {
            --         n = G.UIT.C,
            --         config = { aligh = "bm", minh = 0.4},
            --         nodes = {
            --             {
            --                 n = G.UIT.C,
            --                 config = {
            --                     ref_table = card,
            --                     align = "m",
            --                     colour = G.C.JOKER_GREY,
            --                     r = 0.05,
            --                     padding = 0.06,
            --                     func = "blueprint_compat"
            --                 },
            --                 nodes = {
            --                     {
            --                         n = G.UIT.T,
            --                         config = {
            --                             ref_table = card.ability.extra,
            --                             ref_value = "loop_started_ui",
            --                             colour = G.C.UI.TEXT_LIGHT,
            --                             scale = 0.32 * 0.8
            --                         }
            --                     }
            --                 }
            --             }
            --         }
            --     }
            -- } or nil
        }
    end,
    -- update = function(self, card, front)
    --     if G.STAGE == G.STAGES.RUN then
    --         if card.ability.extra.loop_started then
    --             card.ability.extra.loop_started_ui = "loop started"
    --         else
    --             card.ability.extra.loop_started_ui = "loop not started"
    --         end
    --     end
    -- end,
    config = {
        extra = {
            -- loop_started_ui = "loop not started",
            charges = 0,
            loop_started = false,
            loop_ante = 0, --for visuals only
            days = 734 --just for display
        }
    },
    atlas = "jokers_atlas",
    pos = {x=10,y=HODGE.atlas_y.soul[4]},
    soul_pos = {x=10,y=HODGE.atlas_y.legendary[1]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.setting_blind and G.jokers.cards[#G.jokers.cards] ~= card and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end
            if my_pos and G.jokers.cards[my_pos + 1] and not SMODS.is_eternal(G.jokers.cards[my_pos + 1], card) and not G.jokers.cards[my_pos + 1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos + 1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        card.ability.extra.charges = card.ability.extra.charges + 1
                        card:juice_up(0.8,0.8)
                        sliced_card:start_dissolve({ HEX("ff00e4") }, nil, 1.6)
                        --play_sound('slice1', 0.96 + math.random() * 0.08)
                        return true
                    end
                }))
                return {
                    message = "...",
                    colour = G.C.RED,
                    no_juice = true
                }
            end
        end
        if context.starting_shop and G.GAME.hodge_last_blind_type == 'Boss' and not context.blueprint then
            if G.GAME.hodge_loop_save and card.ability.extra.loop_started then
                if card.ability.extra.charges > 0 then
                    card.ability.extra.charges = card.ability.extra.charges + 1
                else
                    G.GAME.hodge_loop_incoming = true
                    print("load")
                    savetext = STR_UNPACK(G.GAME.hodge_loop_save)
                    G.E_MANAGER:add_event(
                        Event({
                            trigger = "after",
                            delay = G.SETTINGS.GAMESPEED,
                            func = function()
                                G:delete_run()
                                G:start_run({
                                    savetext = STR_UNPACK(G.GAME.hodge_loop_save)
                                })
                                print("loaded")
                                return true --HOW DID YOU FORGET THIS. THIS PREVENTS AN INFINITE LOOP YOU DUMBASS
                            end
                        }),
                        "other"
                    )
                end
            else
                card.ability.extra.loop_started = true
                print("save")
                G.GAME.hodge_loop_save = STR_PACK(G.culled_table)
                card.ability.extra.loop_ante = G.GAME.round_resets.ante
                G.E_MANAGER:add_event(
                    Event({
                        trigger = "after",
                        delay = G.SETTINGS.GAMESPEED,
                        func = function()
                            G.GAME.hodge_loop_save = STR_PACK(G.culled_table)
                            print("saved")
                            return true --HOW DID YOU FORGET THIS. THIS PREVENTS AN INFINITE LOOP YOU DUMBASS
                        end
                    }),
                    "other"
                )
            end
        end
    end, --TODO: make this joker survive the time loop. maybe hook save_run or maybye save to a profile (G.PROFILES[G.SETTINGS.profile].var_name)
    blueprint_compat = false,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','mlp')
    end
}
