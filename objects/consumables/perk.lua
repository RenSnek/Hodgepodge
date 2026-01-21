--- Music ---

-- SMODS.Sound {
--     key = "music_powerpack",
--     path = "mus_powerpack.ogg",
--     volume = 0.5,
--     sync = {
--         ['music1'] = true,
--         ['music2'] = true,
--         ['music3'] = true,
--         ['music4'] = true,
--         ['music5'] = true,
--     },
--     select_music_track = function(self)
--         -- stole this logic from aikos lol
--         return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == 'power' and 100 or nil
--     end
-- }

--- DEFINE CONSUMABLE TYPE ---

SMODS.ConsumableType {
    key = "perk",
    primary_colour = HEX("FFC700"),
    secondary_colour = HEX("000000"),
    cards = {
        ["crumb"] = true,
    },
    select_card = "consumeables"
}

SMODS.UndiscoveredSprite {
    key = "perk",
    atlas = "perk_undiscovered_atlas",
    pos = {x=0,y=0},
    no_overlay = true
}

local is_eternal_hook = SMODS.is_eternal
function SMODS.is_eternal(card, trigger)
    if card and card.ability and card.ability.extra and card.ability.extra.activated and card.ability.extra.triggers_left > 0 then
        return true
    end
    return is_eternal_hook(card,trigger)
end

SMODS.Consumable { -- Crumb (+3 Hand size)
    key = "drain",
    set = "perk",
    atlas = "perk_atlas",
    pos = {x=2,y=0},
    display_size = {w=67,h=68},
    cost = 4,
    config = {
        -- max_highlighted = 999,
        extra = {
            blind_reduce = {0.1,0.2,0.3},
            hands = 1,

            perk_level = 1,
            max_level = 3,
            factor = 1,
            factor_int = 1, -- Target for value manip, integer only, multiplied with hand size
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = { set = "Other", key = "hodge_tooltip_perklevels"}
        local extra = card.ability.extra
        return {
            vars = {
                extra.blind_reduce[1]*extra.factor*100 .. (extra.perk_level==1 and "%" or ""),
                extra.blind_reduce[2]*extra.factor*100 .. (extra.perk_level==2 and "%" or ""),
                extra.blind_reduce[3]*extra.factor*100 .. (extra.perk_level==3 and "%" or ""),

                extra.hands*extra.factor_int,

                extra.perk_level,
                extra.max_level,
                colours = {
                    extra.perk_level==1 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level==2 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level==3 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,

                    extra.perk_level>=2 and G.C.FILTER or G.C.UI.TEXT_INACTIVE, 
                    extra.perk_level>=2 and G.C.BLUE or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level>=2 and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,

                    extra.perk_level>=3 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level>=3 and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
                }
            }
        }
    end,
    can_use = function(self,card)
        return G.hand and G.GAME.blind.in_blind
    end,
    use = function(self,card,area,copier)
        local blind_reduce = card.ability.extra.blind_reduce[card.ability.extra.perk_level]*card.ability.extra.factor
        local blind_reduce_chips = math.max(math.floor(G.GAME.blind.chips * blind_reduce),1)
        local create_event = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.8,
                func = function()
                    if G.hand_text_area.blind_chips then
                        local new_chips = G.GAME.blind.chips - blind_reduce_chips
                        local mod_text = number_format(-blind_reduce_chips)
                        G.GAME.blind.chips = new_chips
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        local chips_UI = G.hand_text_area.blind_chips
                        G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                        G.HUD_blind:recalculate()
                        attention_text({
                            text = mod_text,
                            scale = 0.8,
                            hold = 0.7,
                            cover = chips_UI.parent,
                            cover_colour = G.C.RED,
                            align = 'cm'
                        })
                        chips_UI:juice_up()
                        play_sound('chips2')
                    else
                        return false
                    end
                    return true
                end
            }))
        end
        create_event()

        if card.ability.extra.perk_level >= 2 then
            ease_hands_played(1)
        end

        if card.ability.extra.perk_level >= 3 then
            for _,target_card in ipairs(G.hand.cards) do
                if target_card.debuff then
                    SMODS.debuff_card(target_card,"prevent_debuff","hodge_drain")
                    target_card:juice_up()
                end
            end
            for _,target_card in ipairs(G.deck.cards) do
                if target_card.debuff then
                    SMODS.debuff_card(target_card,"prevent_debuff","hodge_drain")
                    -- target_card:juice_up()
                end
            end
            for _,target_card in ipairs(G.jokers.cards) do
                if target_card.debuff then
                    SMODS.debuff_card(target_card,"prevent_debuff","hodge_drain")
                    target_card:juice_up()
                end
            end
            for _,target_card in ipairs(G.consumeables.cards) do
                if target_card.debuff then
                    SMODS.debuff_card(target_card,"prevent_debuff","hodge_drain")
                    target_card:juice_up()
                end
            end
        end
    end,
    in_pool = function(self,args)
        return true, {allow_duplicates = true}
    end,
    add_to_deck = function(self,card,from_debuff)
        if not (from_debuff or card.from_quantum) then
            for _,consumable in ipairs(G.consumeables.cards) do
                if consumable ~= card and consumable.ability.name == card.ability.name and not consumable.getting_sliced then
                    if (consumable.ability.extra.perk_level < consumable.ability.extra.max_level) and not consumable.ability.extra.activated then
                        card:start_dissolve()
                        card.getting_sliced = true
                        
                        consumable.config.center:level_up(consumable,card.ability.extra.perk_level,card)
                        break
                    end
                end
            end
        end
    end,
    level_up = function(self,card,levels,merged)
        local levels_capped = math.max(math.min(card.ability.extra.perk_level + levels, card.ability.extra.max_level),0) - card.ability.extra.perk_level
        card.ability.extra.perk_level = card.ability.extra.perk_level + levels_capped
        
        if merged then
            card.sell_cost = card.sell_cost + merged.sell_cost
        end
    end
}

SMODS.Consumable {
    key = "bellow",
    set = "perk",
    atlas = "perk_atlas",
    pos = {x=3,y=0},
    display_size = {w=67,h=68},
    cost = 4,
    config = {
        -- max_highlighted = 999,
        extra = {
            hand_sizes = {2,5,8},
            blind_reduce = 0.10,
            hands = 1,

            perk_level = 1,
            max_level = 3,
            activated = false,
            triggers_left = 0,
            factor = 1,
            factor_int = 1, -- Target for value manip, integer only, multiplied with hand size
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = { set = "Other", key = "hodge_tooltip_perklevels"}
        local extra = card.ability.extra
        return {
            vars = {
                (extra.perk_level==1 and "+" or "")..extra.hand_sizes[1]*extra.factor_int,
                (extra.perk_level==2 and "+" or "")..extra.hand_sizes[2]*extra.factor_int,
                (extra.perk_level==3 and "+" or "")..extra.hand_sizes[3]*extra.factor_int,
                
                extra.hands*extra.factor_int,
                
                extra.blind_reduce*extra.factor*100,

                extra.perk_level,
                extra.max_level,
                colours = {
                    extra.perk_level==1 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level==2 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level==3 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,

                    extra.perk_level>=2 and G.C.FILTER or G.C.UI.TEXT_INACTIVE, 
                    extra.perk_level>=2 and G.C.BLUE or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level>=2 and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,

                    extra.perk_level>=3 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level>=3 and G.C.UI.TEXT_DARK or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level>=3 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                }
            }
        }
    end,
    can_use = function(self,card)
        return G.hand and G.GAME.blind.in_blind and not card.ability.extra.activated
    end,
    keep_on_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)

        -- Levels 1+ - Increase hand size
        local increase = card.ability.extra.hand_sizes[card.ability.extra.perk_level]*card.ability.extra.factor_int
        G.hand:change_size(increase)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and #G.hand.cards > 0) then
            SMODS.draw_cards(increase)
        end
        card.ability.extra.activated = true
        card.ability.extra.triggers_left = increase
        juice_card_until(card,function() return true end, true)
        card.ability.extra_slots_used = -1

        -- Level 2 - +1 Hand
        if card.ability.extra.perk_level >= 2 then
            ease_hands_played(1)
        end

        -- Level 3 - Blind Reduce
        local blind_reduce = card.ability.extra.blind_reduce*card.ability.extra.factor
        local blind_reduce_chips = math.max(math.floor(G.GAME.blind.chips * blind_reduce),1)
        local downgrade_blind_event = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.8,
                func = function()
                    if G.hand_text_area.blind_chips then
                        local new_chips = G.GAME.blind.chips - blind_reduce_chips
                        local mod_text = number_format(-blind_reduce_chips)
                        G.GAME.blind.chips = new_chips
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        local chips_UI = G.hand_text_area.blind_chips
                        G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                        G.HUD_blind:recalculate()
                        attention_text({
                            text = mod_text,
                            scale = 0.8,
                            hold = 0.7,
                            cover = chips_UI.parent,
                            cover_colour = G.C.RED,
                            align = 'cm'
                        })
                        chips_UI:juice_up()
                        play_sound('chips2')
                    else
                        return false
                    end
                    return true
                end
            }))
        end

        if card.ability.extra.perk_level >= 3 then
            downgrade_blind_event()
        end
    end,
    calculate = function(self,card,context)
        if card.ability.extra.activated and context.after then
            G.hand:change_size(-1)
            card.ability.extra.triggers_left = card.ability.extra.triggers_left - 1
            if card.ability.extra.triggers_left <= 0 then
                G.E_MANAGER:add_event(Event({func = function()
                    card:start_dissolve(nil, nil, 1.6)
                return true end }))
            end
        end
        -- this doesnt work ?? just gonna hook it
        -- if context.check_eternal and card == context.other_card then
        --     if card.ability.extra.activated then
        --         return {no_destroy = true}
        --     end
        -- end
    end,
    in_pool = function(self,args)
        return true, {allow_duplicates = true}
    end,
    add_to_deck = function(self,card,from_debuff)
        if not (from_debuff or card.from_quantum) then
            for _,consumable in ipairs(G.consumeables.cards) do
                if consumable ~= card and consumable.ability.name == card.ability.name and not consumable.getting_sliced then
                    if (consumable.ability.extra.perk_level < consumable.ability.extra.max_level) and not consumable.ability.extra.activated then
                        card:start_dissolve()
                        card.getting_sliced = true
                        
                        consumable.config.center:level_up(consumable,card.ability.extra.perk_level,card)
                        break
                    end
                end
            end
        end
    end,
    level_up = function(self,card,levels,merged)
        local levels_capped = math.max(math.min(card.ability.extra.perk_level + levels, card.ability.extra.max_level),0) - card.ability.extra.perk_level
        card.ability.extra.perk_level = card.ability.extra.perk_level + levels_capped
        
        if merged then
            card.sell_cost = card.sell_cost + merged.sell_cost
        end
    end
}

SMODS.Consumable {
    key = "crumb",
    set = "perk",
    atlas = "perk_atlas",
    pos = {x=0,y=2},
    display_size = {w=67,h=68},
    cost = 4,
    config = {
        -- max_highlighted = 999,
        extra = {
            hand_sizes = {2,5,8},
            perk_level = 1,
            max_level = 3,
            factor_int = 1, -- Target for value manip, integer only, multiplied with hand size
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = { set = "Other", key = "hodge_tooltip_perklevels"}
        local extra = card.ability.extra
        return {
            vars = {
                (extra.perk_level==1 and "+" or "")..extra.hand_sizes[1]*extra.factor_int,
                (extra.perk_level==2 and "+" or "")..extra.hand_sizes[2]*extra.factor_int,
                (extra.perk_level==3 and "+" or "")..extra.hand_sizes[3]*extra.factor_int,

                extra.perk_level,
                extra.max_level,
                colours = {
                    extra.perk_level==1 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level==2 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                    extra.perk_level==3 and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
                }
            }
        }
    end,
    can_use = function(self,card)
        return true --G.hand and G.GAME.blind.in_blind
    end,
    use = function(self,card,area,copier)
        local increase = card.ability.extra.hand_sizes[card.ability.extra.perk_level]*card.ability.extra.factor_int
        G.hand:change_size(increase)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and #G.hand.cards > 0) then
            SMODS.draw_cards(increase)
        end
    end,
    in_pool = function(self,args)
        return true, {allow_duplicates = true}
    end,
    add_to_deck = function(self,card,from_debuff)
        if not (from_debuff or card.from_quantum) then
            for _,consumable in ipairs(G.consumeables.cards) do
                if consumable ~= card and consumable.ability.name == card.ability.name and not consumable.getting_sliced then
                    if (consumable.ability.extra.perk_level < consumable.ability.extra.max_level) and not consumable.ability.extra.activated then
                        card:start_dissolve()
                        card.getting_sliced = true
                        
                        consumable.config.center:level_up(consumable,card.ability.extra.perk_level,card)
                        break
                    end
                end
            end
        end
    end,
    level_up = function(self,card,levels,merged)
        local levels_capped = math.max(math.min(card.ability.extra.perk_level + levels, card.ability.extra.max_level),0) - card.ability.extra.perk_level
        card.ability.extra.perk_level = card.ability.extra.perk_level + levels_capped
        --card.ability.extra.hand_size = card.ability.extra.hand_size + (levels_capped * 5)
        if merged then
            card.sell_cost = card.sell_cost + merged.sell_cost
        end
    end
}

--- BOOSTERS ---

-- SMODS.Booster {
--     key = "power_booster_1",
--     atlas = "booster_atlas",
--     pos = {x=0,y=0},
--     kind = "power",
--     config = {extra = 2, choose = 1},
--     weight = 0.5,
--     draw_hand = true,
--     group_key = "k_hodge_power_booster",
--     create_card = function(self,card,i)
--         return {
--             set = "power",
--             key_append = "power_booster",
--             skip_materialize = true,
--             area = G.pack_cards
--         }
--     end
-- }

-- SMODS.Booster {
--     key = "power_booster_2",
--     atlas = "booster_atlas",
--     pos = {x=1,y=0},
--     kind = "power",
--     config = {extra = 2, choose = 1},
--     weight = 0.5,
--     draw_hand = true,
--     group_key = "k_hodge_power_booster",
--     create_card = function(self,card,i)
--         return {
--             set = "power",
--             key_append = "power_booster",
--             skip_materialize = true,
--             area = G.pack_cards
--         }
--     end
-- }

-- SMODS.Booster {
--     key = "power_booster_jumbo",
--     atlas = "booster_atlas",
--     pos = {x=2,y=0},
--     kind = "power",
--     config = {extra = 4, choose = 1},
--     weight = 0.5,
--     draw_hand = true,
--     group_key = "k_hodge_power_booster",
--     create_card = function(self,card,i)
--         return {
--             set = "power",
--             key_append = "power_booster",
--             skip_materialize = true,
--             area = G.pack_cards
--         }
--     end
-- }

-- SMODS.Booster {
--     key = "power_booster_mega",
--     atlas = "booster_atlas",
--     pos = {x=3,y=0},
--     kind = "power",
--     config = {extra = 4, choose = 2},
--     weight = 0.2,
--     draw_hand = true,
--     group_key = "k_hodge_power_booster",
--     create_card = function(self,card,i)
--         return {
--             set = "power",
--             key_append = "power_booster",
--             skip_materialize = true,
--             area = G.pack_cards
--         }
--     end
-- }