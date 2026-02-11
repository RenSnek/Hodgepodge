--- Music ---

-- SMODS.Sound {
--     key = "music_mysterypack",
--     path = "mus_mysterypack.ogg",
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
--         return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == 'mystery' and 100 or nil
--     end
-- }

--- DEFINE CONSUMABLE TYPE ---

-- Loof: (Loof means palm of the hand) 
-- Acing Aim: 
-- Highest Spires: Convert 3 cards to Ladders
-- Mr Seeps: Convert 3 cards to Snakes
-- Err Poem: 
-- Her Oath Pin: Create a random pact (Add alongside pacts lol)
-- Solver: Create last used Mystery card
-- At Choir: Create a random cassette (Add alongside cassettes lol)
-- St Juice:  
-- Rem Hit: Create a random Power Card (A rem is a unit of health effects from radiation) 
-- Woeful Horn Fete: Create 2 random Potion Ingredients (Add alongside potions lol)
-- Nth Tergs: (A terg is like a part of an insects body or smth)
-- Hand n Game: 
-- Hated: 
-- Mace Repent: 
-- Lived: Convert 3 cards to Suns
-- We Rot: Convert 3 cards to Moons
-- Tsar: 
-- Mono: Convert 3 cards to suit of leftmost card
-- Uns: Convert 3 cards to rank of rightmost card
-- Gem End Jut: 
-- Low'r'd: Decrease rank of all held cards by 1

SMODS.ConsumableType {
    key = "mystery",
    default = 'c_hodge_highestspires',
    primary_colour = HEX("DD2020"),
    secondary_colour = G.C.SECONDARY_SET.Tarot,
    collection_rows = {5,6},
    shop_rate = 1
}

-- SMODS.UndiscoveredSprite {
--     key = "perk",
--     atlas = "perk_undiscovered_atlas",
--     pos = {x=0,y=0},
--     no_overlay = true
-- }

-- SMODS.Consumable {
--     key = 'loof',
--     set = 'mystery',
--     atlas = "anagrarot_atlas",
--     pos = {x=0,y=0},
--     loc_vars = function(self, info_queue, card)
--         return {vars = {}}
--     end,
--     can_use = function(self,card)
--         return true
--     end
-- }

SMODS.Consumable {
    key = 'highestspires',
    set = 'mystery',
    atlas = "anagrarot_atlas",
    pos = {x=2,y=0},
    config = { max_highlighted = 3, suit_conv = 'hodge_ladders' },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.max_highlighted,
            localize(card.ability.suit_conv,'suits_plural'),
            colours = { G.C.SUITS[card.ability.suit_conv] }
        }}
    end
}
SMODS.Consumable {
    key = 'mrseeps',
    set = 'mystery',
    atlas = "anagrarot_atlas",
    pos = {x=3,y=0},
    config = { max_highlighted = 3, suit_conv = 'hodge_snake' },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.max_highlighted,
            localize(card.ability.suit_conv,'suits_plural'),
            colours = { G.C.SUITS[card.ability.suit_conv] }
        }}
    end
}

SMODS.Consumable {
    key = 'solver',
    set = 'mystery',
    atlas = "anagrarot_atlas",
    pos = {x=6,y=0},
    config = {},
    loc_vars = function(self, info_queue, card)
        local solver_c = G.GAME.hodge_last_mystery and G.P_CENTERS[G.GAME.hodge_last_mystery] or nil
        local last_mystery = solver_c and localize { type = 'name_text', key = solver_c.key, set = solver_c.set} or localize('k_none')
        local colour = (not solver_c or solver_c.name == 'Solver') and G.C.RED or G.C.GREEN

        if not (not solver_c or solver_c.name == 'Solver') then
            info_queue[#info_queue+1] = solver_c
        end

        local main_end = {
            {
                n = G.UIT.C,
                config = {align = "bm", padding = 0.02},
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {align = "m", colour = colour, r = 0.05, padding = 0.05},
                        nodes = {
                            { n = G.UIT.T, config = { text = ' '..last_mystery..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } }
                        }
                    }
                }
            }
        }

        return { vars = {last_mystery}, main_end = main_end}
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    SMODS.add_card({ key = G.GAME.hodge_last_mystery })
                    card:juice_up(0.3,0.5)
                end
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self,card)
        return (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables) and G.GAME.hodge_last_mystery and G.GAME.hodge_last_msytery ~= 'c_hodge_mystery'
    end
}

SMODS.Consumable {
    key = 'lived',
    set = 'mystery',
    atlas = "anagrarot_atlas",
    pos = {x=4,y=1},
    config = { max_highlighted = 3, suit_conv = 'hodge_suns' },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.max_highlighted,
            localize(card.ability.suit_conv,'suits_plural'),
            colours = { G.C.SUITS[card.ability.suit_conv] }
        }}
    end
}
SMODS.Consumable {
    key = 'werot',
    set = 'mystery',
    atlas = "anagrarot_atlas",
    pos = {x=5,y=1},
    config = { max_highlighted = 3, suit_conv = 'hodge_moons' },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.max_highlighted,
            localize(card.ability.suit_conv,'suits_plural'),
            colours = { G.C.SUITS[card.ability.suit_conv] }
        }}
    end
}

SMODS.Consumable {
    key = 'mono',
    set = 'mystery',
    atlas = "anagrarot_atlas",
    pos = {x=7,y=1},
    config = {max_highlighted = 4},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.max_highlighted
        }}
    end,
    use = function(self,card,area,copier)
        local highlighted = {}
        for _,card in ipairs(G.hand.cards) do
            if card.highlighted then
                table.insert(highlighted,card)
            end
        end
        G.E_MANAGER:add_event(Event({trigger='after',delay=0.4,func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true end}))

        for i = 1, #highlighted do
            local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    highlighted[i]:flip()
                    play_sound('card1', percent)
                    highlighted[i]:juice_up(0.3,0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    assert(SMODS.change_base(highlighted[i],highlighted[1].base.suit))
                    return true
                end
            }))
        end
        for i = 1, #highlighted do
            local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    highlighted[i]:juice_up(0.3,0.3)
                    return true
                end
            }))
        end
    end,
    can_use = function(self,card)
        local highlighted = {}
        for _,card in ipairs(G.hand.cards) do
            if card.highlighted then
                table.insert(highlighted,card)
            end
        end
        return G.hand and #highlighted <= card.ability.max_highlighted and #highlighted > 1 and not SMODS.has_no_suit(highlighted[1])
    end
}

SMODS.Consumable {
    key = 'uns',
    set = 'mystery',
    atlas = "anagrarot_atlas",
    pos = {x=8,y=1},
    config = {max_highlighted = 3},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.max_highlighted
        }}
    end,
    use = function(self,card,area,copier)
        local highlighted = {}
        for _,card in ipairs(G.hand.cards) do
            if card.highlighted then
                table.insert(highlighted,card)
            end
        end
        G.E_MANAGER:add_event(Event({trigger='after',delay=0.4,func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true end}))

        for i = 1, #highlighted do
            local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    highlighted[i]:flip()
                    play_sound('card1', percent)
                    highlighted[i]:juice_up(0.3,0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    assert(SMODS.modify_rank(highlighted[i],highlighted[#highlighted]:get_id()-highlighted[i]:get_id()))
                    return true
                end
            }))
        end
        for i = 1, #highlighted do
            local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    highlighted[i]:juice_up(0.3,0.3)
                    return true
                end
            }))
        end
    end,
    can_use = function(self,card)
        local highlighted = {}
        for _,card in ipairs(G.hand.cards) do
            if card.highlighted then
                table.insert(highlighted,card)
            end
        end
        return G.hand and #highlighted <= card.ability.max_highlighted and #highlighted > 1 and not SMODS.has_no_rank(highlighted[#highlighted])
    end
}

SMODS.Consumable {
    key = 'lowrd',
    set = 'mystery',
    atlas = "anagrarot_atlas",
    pos = {x=10,y=1},
    config = {},
    loc_vars = function(self, info_queue, card)
        return {vars = {
        }}
    end,
    use = function(self,card,area,copier)
        G.E_MANAGER:add_event(Event({trigger='after',delay=0.4,func = function()
                play_sound("tarot1")
                card:juice_up(0.3, 0.5)
                return true end}))

        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip()
                        play_sound('card1', percent)
                        G.hand.cards[i]:juice_up(0.3,0.3)
                        return true
                    end
                }))
            end
        end
        delay(0.2)
        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        assert(SMODS.modify_rank(G.hand.cards[i],-1))
                        return true
                    end
                }))
            end
        end
        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip()
                        play_sound('tarot2', percent, 0.6)
                        G.hand.cards[i]:juice_up(0.3,0.3)
                        return true
                    end
                }))
            end
        end
    end,
    can_use = function(self,card)
        return G.hand and #G.hand.cards > #G.hand.highlighted 
    end
}

--- BOOSTERS ---

SMODS.Booster {
    key = "mystery_booster_1",
    atlas = "booster_atlas",
    pos = {x=0,y=1},
    kind = "mystery",
    config = {extra = 3, choose = 1},
    weight = 0.5,
    draw_hand = true,
    group_key = "k_hodge_mystery_booster",
    create_card = function(self,card,i)
        return {
            set = "mystery",
            key_append = "mystery_booster",
            skip_materialize = true,
            area = G.pack_cards
        }
    end
}

SMODS.Booster {
    key = "mystery_booster_2",
    atlas = "booster_atlas",
    pos = {x=1,y=1},
    kind = "mystery",
    config = {extra = 3, choose = 1},
    weight = 1,
    draw_hand = true,
    group_key = "k_hodge_mystery_booster",
    create_card = function(self,card,i)
        return {
            set = "mystery",
            key_append = "mystery_booster",
            skip_materialize = true,
            area = G.pack_cards
        }
    end
}

SMODS.Booster {
    key = "mystery_booster_jumbo",
    atlas = "booster_atlas",
    pos = {x=2,y=1},
    kind = "mystery",
    config = {extra = 5, choose = 1},
    weight = 1,
    draw_hand = true,
    group_key = "k_hodge_mystery_booster",
    create_card = function(self,card,i)
        return {
            set = "mystery",
            key_append = "mystery_booster",
            skip_materialize = true,
            area = G.pack_cards
        }
    end
}

SMODS.Booster {
    key = "mystery_booster_mega",
    atlas = "booster_atlas",
    pos = {x=3,y=1},
    kind = "mystery",
    config = {extra = 5, choose = 2},
    weight = 0.25,
    draw_hand = true,
    group_key = "k_hodge_mystery_booster",
    create_card = function(self,card,i)
        return {
            set = "mystery",
            key_append = "mystery_booster",
            skip_materialize = true,
            area = G.pack_cards
        }
    end
}