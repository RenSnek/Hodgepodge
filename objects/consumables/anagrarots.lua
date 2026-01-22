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
-- Ice Juts:  
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