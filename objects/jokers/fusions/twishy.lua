if FusionJokers then

    SMODS.Joker {
        key = "twishy",
        loc_vars = function (self,info_queue,card)
            local total_xmult = 1
            if G.playing_cards then
                for k,currentCard in pairs(G.playing_cards) do
                    if HODGE.table_contains(HODGE.elements_of_harmony,currentCard.seal) then
                        total_xmult = total_xmult + card.ability.extra.xmult_per_seal
                    end
                end
            end
            return {
                vars = {
                    card.ability.extra.xmult_per_seal,
                    total_xmult
                }
            }
        end,
        config = {
            extra = {
                xmult_per_seal = 0.1
            }
        },
        atlas = "jokers_atlas",
        pos = {x=0,y=HODGE.atlas_y.misc[1]},
        rarity = "fuse_fusion",
        cost = 10,
        calculate = function(self,card,context)
            if context.joker_main then
                -- Twilight Effect
                
                local eligible_sealless_cards = {}
                for k, v in pairs(context.scoring_hand) do
                    if v.ability.set == 'Default' and (not v.seal) then
                        table.insert(eligible_sealless_cards, v)
                    end
                end
                if HODGE.table_true_size(eligible_sealless_cards) > 0 then 
                    local over = false
                    local temp_pool = eligible_sealless_cards or {}
                    -- local eligible_card = pseudorandom_element(temp_pool, pseudoseed("magic"))
                    for _,scoring_card in ipairs(temp_pool) do
                        local selected_element = pseudorandom_element(HODGE.elements_of_harmony, pseudoseed("twishy"))
                        scoring_card:set_seal(selected_element, nil, true) -- if you queue it the other jokers can still choose it as if it has no seal
                        G.E_MANAGER:add_event(Event({func = function()
                            play_sound("tarot1")
                            card:juice_up(0.3, 0.5)
                            return true end}))
                    end
                end

                -- Fluttershy Effect
                local total_xmult = 1
                for k,currentCard in pairs(G.playing_cards) do
                    if HODGE.table_contains(HODGE.elements_of_harmony,currentCard.seal) then
                        total_xmult = total_xmult + card.ability.extra.xmult_per_seal
                    end
                end
                return {xmult = total_xmult}
            end
        end,
        blueprint_compat = true,
        set_badges = function(self,card,badges)
            badges[#badges+1] = HODGE.badge('category','mlp')
            badges[#badges+1] = HODGE.badge('credit','jorse')
        end
    }

    FusionJokers.fusions:register_fusion{
        jokers = {
            { name = "j_hodge_fluttershy" },
            { name = "j_hodge_twilightsparkle" }
        },
        result_joker = "j_hodge_twishy",
        cost = 12
    }
    
else
    HODGE.fake_locked_joker("twishy")
end