--- Music ---

SMODS.Sound {
    key = "music_powerpack",
    path = "mus_powerpack.ogg",
    volume = 0.5,
    sync = {
        ['music1'] = true,
        ['music2'] = true,
        ['music3'] = true,
        ['music4'] = true,
        ['music5'] = true,
    },
    select_music_track = function(self)
        -- stole this logic from aikos lol
        return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == 'power' and 100 or nil
    end
}

--- DEFINE CONSUMABLE TYPE ---

SMODS.ConsumableType {
    key = "power",
    primary_colour = HEX("FF0000"),
    secondary_colour = HEX("555555"),
    cards = {
        ["chaos"] = true,
        ["umbrakinesis"] = true,
        ["size"] = true,
        ["immortality"] = true,
        ["aquakinesis"] = true,
        ["toxigenesis"] = true,
        ["symbiosis"] = true,
        ["friendship"] = true,
        ["glitch"] = true
    },
    collection_rows = {3,3},
    shop_rate = 1,

}

SMODS.UndiscoveredSprite {
    key = "power",
    atlas = "power_atlas",
    pos = {x=1,y=0},
    no_overlay = true
}

SMODS.Consumable { -- Chaos (Applies Terry)
    key = "chaos",
    set = "power",
    atlas = "power_atlas",
    pos = {x=2,y=0},
    cost = 3,
    config = {
        max_highlighted = 0,
        extra = "e_hodge_terry"
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[(card.edition or self.config).extra]
        return {vars = {}}
    end,
    can_use = function(self,card)
        local eligible_editionless_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and (not v.edition) then
                table.insert(eligible_editionless_jokers, v)
            end
        end
        return HODGE.table_true_size(eligible_editionless_jokers) > 0
    end,
    use = function(self,card,area,copier)
        local eligible_editionless_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and (not v.edition) then
                table.insert(eligible_editionless_jokers, v)
            end
        end
        local temp_pool = eligible_editionless_jokers or {}
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            local over = false
            local eligible_card = pseudorandom_element(temp_pool, pseudoseed("chaos"))
            eligible_card:set_edition({["hodge_terry"] = true}, true)
            check_for_unlock({type = 'have_edition'})
        return true end }))
    end
}

SMODS.Consumable { -- Umbrakinesis (Applies Black Hole)
    key = "umbrakinesis",
    set = "power",
    atlas = "power_atlas",
    pos = {x=3,y=0},
    cost = 3,
    config = {
        max_highlighted = 1,
        extra = "m_hodge_blackhole"
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[(card.ability or self.config).extra]
        return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    can_use = function(self,card)
        return #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0
    end,
    use = function(self,card,area,copier)
        for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true end}))
            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.hand.highlighted[i]:set_ability(G.P_CENTERS["m_hodge_blackhole"])
                return true end}))
            
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function() G.hand:unhighlight_all(); return true end}))
    end
}

SMODS.Consumable { -- Dimension (Applies Big)
    key = "dimension",
    set = "power",
    atlas = "power_atlas",
    pos = {x=0,y=1},
    cost = 3,
    config = {
        max_highlighted = 0,
        extra = "e_hodge_big"
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[(card.edition or self.config).extra]
        return {vars = {}}
    end,
    can_use = function(self,card)
        local eligible_editionless_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and (not v.edition) then
                table.insert(eligible_editionless_jokers, v)
            end
        end
        return (HODGE.table_true_size(eligible_editionless_jokers) > 0) and (#G.jokers.cards < G.jokers.config.card_limit)
    end,
    use = function(self,card,area,copier)
        local eligible_editionless_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and (not v.edition) then
                table.insert(eligible_editionless_jokers, v)
            end
        end
        local temp_pool = eligible_editionless_jokers or {}
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            local over = false
            local eligible_card = pseudorandom_element(temp_pool, pseudoseed("dimension"))
            eligible_card:set_edition({["hodge_big"] = true}, true)
            check_for_unlock({type = 'have_edition'})
        return true end }))
    end
}


---- THIS IS NOW THE OUROBOROS SPECTRAL
-- SMODS.Consumable { -- Immortality (Applies Revive)
--     key = "immortality",
--     set = "power",
--     atlas = "power_atlas",
--     pos = {x=1,y=1},
--     cost = 3,
--     config = {
--         max_highlighted = 1,
--         extra = "hodge_revive"
--     },

--     loc_vars = function(self, info_queue, card)
--         info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
--         return {vars = {(card.ability or self.config).max_highlighted}}
--     end,
--     can_use = function(self,card)
--         return #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0
--     end,
--     use = function(self,card,area,copier)
--         for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
--             G.E_MANAGER:add_event(Event({func = function()
--                 play_sound("tarot1")
--                 card:juice_up(0.3, 0.5)
--                 return true end}))
            
--             G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
--                 G.hand.highlighted[i]:set_seal(card.ability.extra, nil, true)
--                 return true end}))
            
--             delay(0.5)
--         end
--         G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function() G.hand:unhighlight_all(); return true end}))
--     end
-- }

SMODS.Consumable { -- Aquakinesis (Applies Water Damage)
    key = "aquakinesis",
    set = "power",
    atlas = "power_atlas",
    pos = {x=2,y=1},
    cost = 3,
    config = {
        max_highlighted = 2,
        extra = "m_hodge_waterdamage"
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[(card.ability or self.config).extra]
        return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    can_use = function(self,card)
        return #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0
    end,
    use = function(self,card,area,copier)
        for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true end}))
            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.hand.highlighted[i]:set_ability(G.P_CENTERS["m_hodge_waterdamage"])
                return true end}))
            
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function() G.hand:unhighlight_all(); return true end}))
    end
}

SMODS.Consumable { -- Toxigenesis (Applies Asbestos)
    key = "toxigenesis",
    set = "power",
    atlas = "power_atlas",
    pos = {x=3,y=1},
    cost = 3,
    config = {
        max_highlighted = 1,
        extra = "m_hodge_asbestos"
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[(card.ability or self.config).extra]
        return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    can_use = function(self,card)
        return #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0
    end,
    use = function(self,card,area,copier)
        for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true end}))
            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.hand.highlighted[i]:set_ability(G.P_CENTERS["m_hodge_asbestos"])
                return true end}))
            
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function() G.hand:unhighlight_all(); return true end}))
    end
}

SMODS.Consumable { -- Symbiosis (Applies Parasite)
    key = "symbiosis",
    set = "power",
    atlas = "power_atlas",
    pos = {x=0,y=2},
    cost = 3,
    config = {
        max_highlighted = 0,
        extra = "e_hodge_parasite"
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[(card.edition or self.config).extra]
        return {vars = {}}
    end,
    can_use = function(self,card)
        local eligible_editionless_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and (not v.edition) then
                table.insert(eligible_editionless_jokers, v)
            end
        end
        return (HODGE.table_true_size(eligible_editionless_jokers) > 0)
    end,
    use = function(self,card,area,copier)
        local eligible_editionless_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and (not v.edition) then
                table.insert(eligible_editionless_jokers, v)
            end
        end
        local temp_pool = eligible_editionless_jokers or {}
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            local over = false
            local eligible_card = pseudorandom_element(temp_pool, pseudoseed("size"))
            eligible_card:set_edition({["hodge_parasite"] = true}, true)
            check_for_unlock({type = 'have_edition'})
        return true end }))
    end
}

---- THIS IS NOW THE COVEN SPECTRAL
-- SMODS.Consumable { -- Friendship (Applies Magic Seal)
--     key = "friendship",
--     set = "power",
--     atlas = "power_atlas",
--     pos = {x=1,y=2},
--     cost = 3,
--     config = {
--         max_highlighted = 1,
--         extra = "hodge_magic"
--     },
--     loc_vars = function(self, info_queue, card)
--         info_queue[#info_queue+1] = G.P_CENTERS[(card.ability or self.config).extra]
--         return {vars = {(card.ability or self.config).max_highlighted}}
--     end,
--     can_use = function(self,card)
--         return #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0
--     end,
--     use = function(self,card,area,copier)
--         for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
--             G.E_MANAGER:add_event(Event({func = function()
--                 play_sound("tarot1")
--                 card:juice_up(0.3, 0.5)
--                 return true end}))
            
--             G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
--                 G.hand.highlighted[i]:set_seal("hodge_magic", nil, true)
--                 return true end}))
            
--             delay(0.5)
--         end
--         G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function() G.hand:unhighlight_all(); return true end}))
--     end
-- }

-- GLITCH CURRENTLY CAN'T WORK, AS ANIMATED CONSUMABLES ARENT POSSIBLE WITHOUT PATCHING YET

SMODS.Consumable { -- Glitch (Currently useless)
    key = "glitch",
    set = "power",
    atlas = "anim_power_atlas",
    pos = {x=0,y=0},
    soul_pos = {x=0,y=1},
    cost = 5,
    config = {
        max_highlighted = 2,
        extra = {
            enhancement = "m_hodge_error",
            -- ticks = 0,
            -- ticks_per_frame = 1,
            -- frames = 15
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[(card.ability or self.config).extra.enhancement]
        return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    can_use = function(self,card)
        return #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0
    end,
    use = function(self,card,area,copier)
        for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true end}))
            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.hand.highlighted[i]:set_ability(G.P_CENTERS[card.ability.extra.enhancement])
                return true end}))
            
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function() G.hand:unhighlight_all(); return true end}))
    end,
    -- update = function(self,card,dt)
    --     if card and card.ability then
    --         card.ability.extra.ticks = card.ability.extra.ticks + dt
    --         if card.ability.extra.ticks >= card.ability.extra.ticks_per_frame then
    --             card.ability.extra.ticks = card.ability.extra.ticks - card.ability.extra.ticks_per_frame
    --             card.config.center.pos.x = math.mod(card.config.center.pos.x + 1, card.ability.extra.frames - 1)
    --         end
    --     end
    -- end
    ---- The above actually changes the base sprite for all glitch cards, which is jankyyy. card.children.center:set_sprite_pos might work but it still doesn't run in the collection, packs, etc
}

--- BOOSTERS ---

SMODS.Booster {
    key = "power_booster_1",
    atlas = "booster_atlas",
    pos = {x=0,y=0},
    kind = "power",
    config = {extra = 2, choose = 1},
    weight = 0.5,
    draw_hand = true,
    group_key = "k_hodge_power_booster",
    create_card = function(self,card,i)
        return {
            set = "power",
            key_append = "power_booster",
            skip_materialize = true,
            area = G.pack_cards
        }
    end
}

SMODS.Booster {
    key = "power_booster_2",
    atlas = "booster_atlas",
    pos = {x=1,y=0},
    kind = "power",
    config = {extra = 2, choose = 1},
    weight = 0.5,
    draw_hand = true,
    group_key = "k_hodge_power_booster",
    create_card = function(self,card,i)
        return {
            set = "power",
            key_append = "power_booster",
            skip_materialize = true,
            area = G.pack_cards
        }
    end
}

SMODS.Booster {
    key = "power_booster_jumbo",
    atlas = "booster_atlas",
    pos = {x=2,y=0},
    kind = "power",
    config = {extra = 4, choose = 1},
    weight = 0.5,
    draw_hand = true,
    group_key = "k_hodge_power_booster",
    create_card = function(self,card,i)
        return {
            set = "power",
            key_append = "power_booster",
            skip_materialize = true,
            area = G.pack_cards
        }
    end
}

SMODS.Booster {
    key = "power_booster_mega",
    atlas = "booster_atlas",
    pos = {x=3,y=0},
    kind = "power",
    config = {extra = 4, choose = 2},
    weight = 0.2,
    draw_hand = true,
    group_key = "k_hodge_power_booster",
    create_card = function(self,card,i)
        return {
            set = "power",
            key_append = "power_booster",
            skip_materialize = true,
            area = G.pack_cards
        }
    end
}