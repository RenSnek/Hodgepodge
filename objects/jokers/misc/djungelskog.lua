SMODS.Joker {
    key = "djungelskog",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {}
        }
    end,
    config = {
        extra = {
            power_boost = 2,
            last_left_joker = nil,
            last_right_joker = nil
        }
    },
    atlas = "jokers_atlas",
    pos = {x=4,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=4,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    blueprint_compat = false,
    calculate = function(self,card,context)
    end,
    update = function(self,card,dt)
        if G.jokers and next(SMODS.find_card("j_hodge_djungelskog")) then
            for i,joker in ipairs(G.jokers.cards) do
                if joker == card then
                    local source_id = "hodge_djungelskog_"..card.sort_id
                    --printcard.ability.extra.last_left_joker)
                    if G.jokers.cards[i-1] then --If there's a joker to the left
                        if G.jokers.cards[i-1] ~= HODGE.joker_from_sort_id(card.ability.extra.last_left_joker) then --If it isn't the last known joker to the left
                            --print"--- LEFT ---")
                            --printcard.ability.extra)
                            --printsource_id.."_left")
                            local left_joker = HODGE.joker_from_sort_id(card.ability.extra.last_left_joker)
                            if left_joker ~= nil then --If there's a last known left joker
                                --print"Reset "..left_joker.ability.name)
                                Blockbuster.manipulate_value(left_joker,source_id.."_left",1) --Reset last known left joker
                            end
                            --print"Multiply "..G.jokers.cards[i-1].ability.name.." "..G.jokers.cards[i-1].sort_id)
                            card.ability.extra.last_left_joker = G.jokers.cards[i-1].sort_id --Update last known left joker to current left joker
                            --print(card.ability.extra.last_left_joker or "nil").." | "..G.jokers.cards[i-1].sort_id)
                            --printcard.ability.extra)
                            Blockbuster.manipulate_value(G.jokers.cards[i-1],source_id.."_left",2) --Manip current left joker
                            --print(card.ability.extra.last_left_joker or "nil").." | "..G.jokers.cards[i-1].sort_id)
                            --printcard.ability.extra)
                        end
                    elseif card.ability.extra.last_left_joker then --If there's no joker to the left, and there is a last known left joker
                        --print"--- NONE LEFT ---")
                        local left_joker = HODGE.joker_from_sort_id(card.ability.extra.last_left_joker)
                        if left_joker then
                            --print"Reset "..left_joker.ability.name)
                            Blockbuster.manipulate_value(left_joker,source_id.."_left",1) --Reset last known left joker
                        end
                        card.ability.extra.last_left_joker = nil --Clear last known left joker
                    end

                    if G.jokers.cards[i+1] then --If there's a joker to the right
                        if G.jokers.cards[i+1] ~= HODGE.joker_from_sort_id(card.ability.extra.last_right_joker) then --If it isn't the last known joker to the right
                            --print"--- RIGHT ---")
                            --printsource_id.."_right")
                            local right_joker = HODGE.joker_from_sort_id(card.ability.extra.last_right_joker)
                            if right_joker ~= nil then --If there's a last known right joker
                                --print"Reset "..right_joker.ability.name)
                                Blockbuster.manipulate_value(right_joker,source_id.."_right",1) --Reset last known right joker
                            end
                            --print"Multiply "..G.jokers.cards[i+1].ability.name.." "..G.jokers.cards[i+1].sort_id)
                            card.ability.extra.last_right_joker = G.jokers.cards[i+1].sort_id --Update last known right joker to current right joker
                            Blockbuster.manipulate_value(G.jokers.cards[i+1],source_id.."_right",2) --Manip current right joker
                            --printcard.ability.extra.last_right_joker)
                        end
                    elseif card.ability.extra.last_right_joker then --If there's no joker to the right, and there is a last known right joker
                        --print"--- NONE RIGHT ---")
                        local right_joker = HODGE.joker_from_sort_id(card.ability.extra.last_right_joker)
                        if right_joker then
                            --print"Reset "..right_joker.ability.name)
                            Blockbuster.manipulate_value(right_joker,source_id.."_right",1) --Reset last known right joker
                        end
                        card.ability.extra.last_right_joker = nil --Clear last known right joker
                    end

                    break
                end
            end
        end
    end,
    add_to_deck = function(self,card,from_debuff)
        if not card.from_quantum then --stops it from updating when this card is manipulated (or attempted to manipulate, rather)
            card.ability.extra.last_left_joker = nil
            card.ability.extra.last_right_joker = nil
        end
    end,
    remove_from_deck = function(self,card,from_debuff)
        if not card.from_quantum then
            local source_id = "hodge_djungelskog_"..card.sort_id
            local left_joker = HODGE.joker_from_sort_id(card.ability.extra.last_left_joker)
            local right_joker = HODGE.joker_from_sort_id(card.ability.extra.last_right_joker)
            Blockbuster.manipulate_value(left_joker,source_id.."_left",1)
            Blockbuster.manipulate_value(right_joker,source_id.."_right",1)
            card.ability.extra.last_left_joker = nil
            card.ability.extra.last_right_joker = nil
        end
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','misc')
    end
}

