HODGE = SMODS.current_mod

HODGE.optional_features = function()
    return {
        retrigger_joker = true,
        cardareas = {
            discard = true
        }
    }
end

HODGE.calculate = function(self,context)
    if context.mod_probability then
        local numerator_mult = 1
        for i = 1, #G.GAME.tags do
            if G.GAME.tags[i].key == "tag_hodge_clover" then
                numerator_mult = numerator_mult * 2
            end
        end
        return {
            numerator = context.numerator * numerator_mult
        }
    end
    if context.end_of_round then
        for i = 1, #G.GAME.tags do
            local ret = G.GAME.tags[i]:apply_to_run({type = 'end_of_round'})
        end
    end
end

table.insert(SMODS.other_calculation_keys,"hodge_partial_balance")

----------------------------
----- GLOBAL VARIABLES -----
----------------------------

SMODS.Gradient {
    key = "rainbow",
    colours = {
        G.C.RED,
        G.C.ORANGE,
        G.C.MONEY,
        G.C.GREEN,
        G.C.BLUE,
        G.C.LEGENDARY
    }
}

HODGE.elements_of_harmony = {"hodge_kindness","hodge_honesty","hodge_loyalty","hodge_laughter","hodge_generosity","hodge_magic"}

HODGE.atlas_y = {
    misc      = { 0 },
    joke      = { 2, 13 },
    mlp       = { 4 },
    legendary = { 6 },
    food      = { 11 },
    utdr      = { 12 },
    crossmod  = { 8 },

    soul      = { 1, 3, 5, 7 }
}

-----------------------
----- BLOCKBUSTER -----
-----------------------

Blockbuster.ValueManipulation.CompatStandard {
    key = "hodge_default",
    source_mod = "hodge",
    variable_conventions = {
        full_vars = { --Specific variable names that won't get manipulated
            "odds", --Variables named odds won't get manipulated
            "count",
            "slime_floor",
            "overscore",
            "self_copies",
            "id_table",
            "chip_gain_bonus",
            "unrounded_sell_value",
            "rank",
            "remaining",
            "perk_level",
            "max_level",
            "triggers_left"
        },
        ends_on = { --Variable prefixes that won't get manipulated
            "_loss", --Anything ending in _loss won't get manipulated
            "_neg", --if its bad dont manipulate it
            "_static", --if i specifically specify i want it to not change lol
            "_rank",
            "_count",
        },
        starts_with = {
            "scaling_",
            "base_",
            "time_"
        }
    },

    integer_only_variable_conventions = { -- WILL get manipulated, but will be rounded
        full_vars = {

        },
        ends_on = {
            "_int"
        },
        starts_with = {
            "hands",
            "discards",
            "hand_size"
        }
    },

    exempt_jokers = {
        j_hodge_placeholder = true,
        j_hodge_spaghettification = true,
        j_hodge_catapult = true,
        j_hodge_cocksley = true,
        j_hodge_synccrystal = true,
        j_hodge_mergedown = true,
        j_hodge_lowpercent = true,
        j_hodge_stopsign = true,
        j_hodge_lostcount = true,
        j_hodge_biggamba = true,
        j_hodge_sou = true,
        j_hodge_twilightsparkle = true,
        j_hodge_rainbowdash = true,
        j_hodge_pinkiepie = true,
        j_hodge_applejack = true,
        j_hodge_rainbowfactory = true,
        j_hodge_butterflies = true,
        j_hodge_littlemissrarity = true,
        j_hodge_lumi = true,
        j_hodge_david = true,
        j_hodge_djungelskog = true,
        j_hodge_missingno = true,
        j_hodge_badegg = true,
        j_hodge_runerigus = true,
        j_hodge_timeloop = true,
        j_hodge_foreverweedbrownie = true,
        j_hodge_bluelatro = true,
    }
}

-----------------------------
----- UTILITY FUNCTIONS -----
-----------------------------

-- stole this little number from yahimod
HODGE.load_custom_image = function(filename)
    local full_path = (HODGE.path .. "customimages/" .. filename)
    local file_data = assert(NFS.newFileData(full_path),("Failed to create file_data"))
    local tempimagedata = assert(love.image.newImageData(file_data),("Failed to create tempimagedata"))
    return (assert(love.graphics.newImage(tempimagedata),("Failed to create return image")))
end
    

HODGE.starts_with = function(str,start)
    return str:sub(1, #start) == start
end

HODGE.table_contains = function(table,value)
    for i = 1,#table do
        if (table[i] == value) then
            return true
        end
    end
    return false
end

HODGE.load_script = function(path)
    local helper, load_error = SMODS.load_file(path)
    if load_error then
        print("Loading "..path.." failed! Error: "..load_error)
    else
        if helper then
            helper()
        end
    end
end

HODGE.table_true_size = function(table)
    local n = 0
    for k,v in pairs(table) do
        n = n+1
    end
    return n
end

-- Thanks to aikoyori for this one! This is copied directly from the Aikoyori's Shenanigans mod lol
HODGE.mod_card_values = function (table_in, config)
    if not config then config = {} end
    local set = config.set or nil
    local add = config.add or 0
    local multiply = config.multiply or 1
    local keywords = config.keywords or {}
    local unkeyword = config.unkeywords or {}
    local x_protect = config.x_protect or true -- This is my addition! If true and a key starts with x_ and the value is 1, it won't multiply
    local reference = config.reference or table_in
    local function modify_values(table_in, ref)
        for k,v in pairs(table_in) do -- For key, value in the table
            if type(v) == "number" then -- If it's a number
                if (keywords[k] or (HODGE.table_true_size(keywords) < 1)) and not unkeyword[k] then -- If it's in the keywords, OR there's no keywords and it isn't in the unkeywords
                    if ref and ref[k] then -- If it exists in the reference
                        if not (x_protect and (HODGE.starts_with(k,"x_") or HODGE.starts_with(k,"h_x_")) and ref[k] == 1) then
                            table_in[k] = ((set or ref[k]) + add) * multiply -- Set it to (reference's value + add) * multiply
                        end
                    end
                end
            elseif type(v) == "table" then -- If it's a table
                modify_values(v, ref[k]) -- Recurse for values in the table
            end
        end
    end
    if table_in == nil then
        return
    end
    modify_values(table_in, reference)
end

-- Thanks also for this function, aiko
HODGE.deep_copy = function(orig,cutoff_value)
    cutoff_value = cutoff_value or orig
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if orig_type ~= cutoff_value then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                copy[HODGE.deep_copy(orig_key)] = HODGE.deep_copy(orig_value)
            end
        end
    else
        copy = orig
    end
    return copy
end

HODGE.reverse_table = function(table)
    local tab = HODGE.deep_copy(table)
    for i = 1, math.floor(#tab/2), 1 do
        tab[i], tab[#tab-i+1] = tab[#tab-i+i], tab[i]
    end
    return tab
end

HODGE.first_card_merge_down = function(cards,merge) -- Get first card, with compatibility for Merge Down joker
    if merge == nil then
        merge = false
        for _,j in ipairs(G.jokers.cards) do
            if j.ability and j.ability.name == "j_hodge_mergedown" then
                merge = true
            end 
        end
    end
    if merge then
        -- print("all cards")
        return cards
    else
        if cards[1] then
            -- print("first card")
            return {cards[1]}
        else
            -- print("no cards")
            return {}
        end
    end
end

HODGE.joker_from_sort_id = function(id)
    for index,joker in pairs(G.jokers.cards) do
        if joker.sort_id == id then
            return joker
        end
    end
    return nil
end

HODGE.fake_locked_joker = function(key,mod)
    SMODS.Joker {
        key = key.."_fakelocked",
        pos = {x=8,y=9}, -- The locked joker sprite
        rarity = nil,
        discovered = true,
        unlocked = true,
        loc_vars = function(self, info_queue,card)
            return {
                key = "j_hodge_modlock_"..mod
            }
        end,
        in_pool = function(self)
            return false
        end,
        set_card_type_badge = function(self,card,badges)
            return {}
        end,
    }
end

HODGE.hand_level_colour = function(lvl)
    local capped_lvl = math.min(lvl, 7)
    return mix_colours(G.C.HAND_LEVELS[math.floor(capped_lvl)],G.C.HAND_LEVELS[math.ceil(capped_lvl)],1-(capped_lvl-math.floor(capped_lvl)))
end

--  HODGE.bias_shuffle(G.deck.cards,
--      [{
--          match = function(item) return HODGE.table_contains(HODGE.elements_of_harmony,item.seal) end,
--          upper_lim = #G.deck.cards/2
--      }]
--  )
-- HODGE.bias_shuffle_broken = function(list, biases, seed) -- THIS DOESNT WORK!
--     if seed then math.randomseed(seed) end

--     if list[1] and list[1].sort_id then
--         table.sort(list, function (a, b) return (a.sort_id or 1) < (b.sort_id or 2) end)
--     end

--     local function is_allowed(item,index,maxindex)
--         for i,bias in ipairs(biases) do
--             if bias.match(item) then
--                 if bias.upper_lim and bias.upper_lim < index then
--                     return false
--                 end
--                 if bias.lower_lim and (bias.lower_lim > index) and not (maxindex < bias.lower_lim) then
--                     return false
--                 end
--                 -- print("bias passed")
--             end
--         end
--         -- print("all biases passed")
--         return true
--     end

--     for i = #list, 2, -1 do
--         local j = nil
--         local pass = false
--         local emergency_quit = 50
--         while emergency_quit > 0 and not pass do
--             j = math.random(i)
--             pass = is_allowed(list[i],j,i) and is_allowed(list[j],i,i)
--             emergency_quit = emergency_quit - 1
--         end
--         if emergency_quit == 0 then print("emergency quit") end
--         list[i], list[j] = list[j], list[i]
--     end
-- end

HODGE.force_front_shuffle = function(list, condition, lower_bound, seed)
    if seed then math.randomseed(seed) end

    if list[1] and list[1].sort_id then
        table.sort(list, function (a, b) return (a.sort_id or 1) < (b.sort_id or 2) end)
    end

    for i = #list, 2, -1 do
        local j = nil
        j = math.random(i)
        list[i], list[j] = list[j], list[i]
    end

    for i = #list, 2, -1 do
        if condition(list[i]) and i <= lower_bound then
            --print("card where it shouldnt be")
            --print("i =",i,list[i].seal)
            local j = math.random(#list)
            while condition(list[j]) or j <= lower_bound do
                j = math.random(#list)
            end

            --print("j =",j,list[j].seal)
            list[i], list[j] = list[j], list[i]
        end
    end
end

-- Stolen from seals on everything
function HODGE.calculate_quantum_editions(card,effects,context)
    if not card:can_calculate(context.ignore_debuff, context.remove_playing_cards) then return nil end

    context.extra_edition = true
    local extra_editions = HODGE.get_quantum_editions(card)
    table.sort(extra_editions, function(a,b) return G.P_CENTERS["e_"..a].order < G.P_CENTERS["e_"..b].order end)
    local old_edition = card.edition and copy_table(card.edition) or nil
    for i,v in ipairs(extra_editions) do
        local ed_key = "e_"..v
        if G.P_CENTERS[ed_key] then
            local cardedition = {
                [v] = true,
                type = v,
                key = ed_key
            }
            for k,v in pairs(G.P_CENTERS[ed_key].config) do
                cardedition[k] = copy_table(v)
            end
            card.edition = cardedition
            card.ability.extra_edition = ed_key
            G.GAME.triggered_edition = {card.sort_id,ed_key}
            local eval = {edition = card:calculate_edition(context)}
            G.GAME.triggered_edition = nil
            if eval.edition then
                table.insert(effects,eval)
            end
        end
    end
    card.edition = old_edition
    context.extra_edition = nil
end

function HODGE.get_quantum_editions(card)
    if next(SMODS.find_card('j_hodge_laddervizier')) and card.edition then
        local editions = {"foil","holo","polychrome","negative"}
        local quantum_editions = {}
        for i,edition in ipairs(editions) do
            if card.edition.type == edition then
                return quantum_editions
            else
                table.insert(quantum_editions,edition)
            end
        end
    end
    return {}
end


HODGE.badge = function(type,id)
    local badges = {
        category = {
            misc = {
                text = "k_badge_misc",
                bg = G.C.CHIPS,
                colour = G.C.WHITE
            },
            joke = {
                text = "k_badge_joke",
                bg = G.C.GREEN,
                colour = G.C.WHITE
            },
            mlp = {
                text = "k_badge_mlp",
                bg = G.C.PURPLE,
                colour = G.C.WHITE
            },
            pokemon = {
                text = "k_badge_pokemon",
                bg = G.C.MULT,
                colour = G.C.WHITE
            },
            ["pokemon?"] = {
                text = "k_badge_pokemon_maybe",
                bg = G.C.MULT,
                colour = G.C.WHITE
            },
            utdr = {
                text = "k_badge_utdr",
                bg = G.C.MULT,
                colour = G.C.BLACK
            },
        },
        credit = {
            jorse = {
                text = "k_badge_jorse",
                bg = G.C.GREEN,
                colour = G.C.WHITE,
                size = 1.0
            },
            edward = {
                text = "k_badge_edward",
                bg = G.C.CHIPS,
                colour = G.C.WHITE,
                size = 1.0
            },
            pumpkin = {
                text = "k_badge_pumpkin",
                bg = G.C.SUITS.Diamonds,
                colour = G.C.WHITE,
                size = 1.0
            }
        }
    }
    local badge = badges[type][id]
    return create_badge(localize(badge.text), badge.bg, badge.colour, badge.size or 1.2)
end

------------------
----- Sounds -----
------------------

SMODS.Sound {
    key = "poisonogg",
    path = "Poison.ogg"
}

-- SMODS.Sound {
--     key = "music_menu",
--     path = "mus_trailer.ogg",
--     pitch = 1,
--     sync = false,
--     select_music_track = function(self)
--         if G.STATE == G.STATES.MENU then
--             return 999
--         else
--             return false
--         end
--     end
-- }

---------------------------
----- Texture Atlases -----
---------------------------

SMODS.Atlas {
    key = "seal_atlas",
    path = "modded_seals.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "power_atlas",
    path = "powers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "tarot_atlas",
    path = "tarots.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "perk_atlas",
    path = "perks.png",
    px = 67,
    py = 68
}
SMODS.Atlas { --stupid game wont let me have square shaped undiscoveredsprite so i had to improvise
    key = "perk_undiscovered_atlas",
    path = "perks_undiscovered.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "anagrarot_atlas",
    path = "anagrarots.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    -- atlas_table = 'ANIMATION_ATLAS',
    key = "anim_power_atlas",
    path = "animated_powers.png",
    px = 71,
    py = 95,
    -- frames = 15
}

SMODS.Atlas {
    key = "booster_atlas",
    path = "boosters.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "enhancements_atlas",
    path = "enhancements.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "suits_atlas",
    path = "suits.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "modded_mlp_suits_atlas",
    path = "modded_mlp_suits.png",
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = "modded_mlp_suits_2_atlas",
    path = "modded_mlp_suits_2.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "icons_atlas",
    path = "icons.png",
    px = 18,
    py = 18
}

SMODS.Atlas {
    key = "decks_atlas",
    path = "decks.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "sleeves_atlas",
    path = "deck_sleeves.png",
    px = 73,
    py = 95
}

SMODS.Atlas {
    key = "jokers_atlas",
    path = "jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    atlas_table = 'ANIMATION_ATLAS',
    key = "blinds_atlas",
    path = "blinds.png",
    px = 34,
    py = 34,
    frames = 21
}

SMODS.Atlas {
    key = "tags_atlas",
    px = 34,
    py = 34,
    path = "tags.png"
}

SMODS.Atlas {
    key = "modicon",
    px = 32,
    py = 32,
    path = "modicon.png"
}



-----------------------------
----- LOADING SCRIPTS!! -----
-----------------------------

------ Hooks ------
HODGE.load_script("hooks/general.lua")

------ UI ------
HODGE.load_script("customui.lua")

------ Consumables ------
-- Custom Types
HODGE.load_script("objects/consumables/power.lua")
HODGE.load_script("objects/consumables/perk.lua")
HODGE.load_script("objects/consumables/anagrarots.lua")
-- Vanilla Types
HODGE.load_script("objects/consumables/planet.lua")
HODGE.load_script("objects/consumables/spectral.lua")

------ Editions ------
HODGE.load_script("objects/editions/big.lua")
HODGE.load_script("objects/editions/terry.lua")
HODGE.load_script("objects/editions/parasite.lua")
HODGE.load_script("objects/editions/lenticular.lua")

------ Enhancements ------
HODGE.load_script("objects/enhancements/asbestos.lua")
HODGE.load_script("objects/enhancements/blackhole.lua")
HODGE.load_script("objects/enhancements/waterdamage.lua")
HODGE.load_script("objects/enhancements/error.lua")

------ Seals ------
-- Misc
HODGE.load_script("objects/seals/revive.lua")
-- MLP
HODGE.load_script("objects/seals/mlp/loyalty.lua")
HODGE.load_script("objects/seals/mlp/honesty.lua")
HODGE.load_script("objects/seals/mlp/kindness.lua")
HODGE.load_script("objects/seals/mlp/generosity.lua")
HODGE.load_script("objects/seals/mlp/laughter.lua")
HODGE.load_script("objects/seals/mlp/magic.lua")

------ Decks ------
-- HODGE.load_script("objects/decks/jumbo.lua") --Big edition does not correctly affect playing cards.
HODGE.load_script("objects/decks/jimbo.lua")
HODGE.load_script("objects/decks/condemned.lua")
HODGE.load_script("objects/decks/boardgame.lua")
HODGE.load_script("objects/decks/friendship.lua")

----- Suits ------
-- Snakes n Ladders
HODGE.load_script("objects/suits/snake.lua")
HODGE.load_script("objects/suits/ladders.lua")
-- MLP
HODGE.load_script("objects/suits/suns.lua")
HODGE.load_script("objects/suits/moons.lua")

----- Poker Hands ------
HODGE.load_script("objects/hands/snap.lua")

------ Jokers ------
-- Page 1 - Misc
HODGE.load_script("objects/jokers/misc/placeholder.lua")
HODGE.load_script("objects/jokers/misc/brokenrecord.lua")
HODGE.load_script("objects/jokers/misc/spaghettification.lua")
HODGE.load_script("objects/jokers/misc/catapult.lua")
HODGE.load_script("objects/jokers/misc/cocksley.lua")

HODGE.load_script("objects/jokers/misc/ricoshot.lua")
HODGE.load_script("objects/jokers/misc/projectileboost.lua")
HODGE.load_script("objects/jokers/misc/exploded.lua")
HODGE.load_script("objects/jokers/misc/arsenal.lua")
HODGE.load_script("objects/jokers/misc/overkill.lua")

HODGE.load_script("objects/jokers/misc/synccrystal.lua")
HODGE.load_script("objects/jokers/misc/combo.lua")
HODGE.load_script("objects/jokers/misc/mergedown.lua")
HODGE.load_script("objects/jokers/misc/blownaway.lua")
HODGE.load_script("objects/jokers/misc/metamorphosis.lua")
-- Page 2 - Joke
HODGE.load_script("objects/jokers/joke/hydra.lua")
HODGE.load_script("objects/jokers/joke/handcrank.lua")
HODGE.load_script("objects/jokers/joke/cyan.lua")
HODGE.load_script("objects/jokers/joke/disappearingguy.lua")
HODGE.load_script("objects/jokers/joke/lowpercent.lua")

HODGE.load_script("objects/jokers/joke/vestup.lua")
HODGE.load_script("objects/jokers/joke/nft.lua")
HODGE.load_script("objects/jokers/joke/stopsign.lua")
HODGE.load_script("objects/jokers/joke/lostcount.lua")
HODGE.load_script("objects/jokers/joke/biggamba.lua")

HODGE.load_script("objects/jokers/joke/shooketh.lua")
HODGE.load_script("objects/jokers/joke/ppe.lua")
HODGE.load_script("objects/jokers/joke/sou.lua")
HODGE.load_script("objects/jokers/joke/nonejoker.lua")
HODGE.load_script("objects/jokers/joke/parappa.lua")

-- Page 3 - MLP
HODGE.load_script("objects/jokers/mlp/summersun.lua")
HODGE.load_script("objects/jokers/mlp/nightmarenight.lua")
HODGE.load_script("objects/jokers/mlp/twilightsparkle.lua")
HODGE.load_script("objects/jokers/mlp/amber.lua")
HODGE.load_script("objects/jokers/mlp/moonstone.lua")

HODGE.load_script("objects/jokers/mlp/rainbowdash.lua")
HODGE.load_script("objects/jokers/mlp/rarity.lua")
HODGE.load_script("objects/jokers/mlp/pinkiepie.lua")
HODGE.load_script("objects/jokers/mlp/applejack.lua")
HODGE.load_script("objects/jokers/mlp/fluttershy.lua")

HODGE.load_script("objects/jokers/mlp/rainbowfactory.lua")
HODGE.load_script("objects/jokers/mlp/littlemissrarity.lua")
HODGE.load_script("objects/jokers/mlp/cupcakes.lua")
HODGE.load_script("objects/jokers/mlp/applesleepexperiment.lua")
HODGE.load_script("objects/jokers/mlp/butterflies.lua")

-- Page 4 - Legendaries
HODGE.load_script("objects/jokers/misc/lumi.lua")
HODGE.load_script("objects/jokers/joke/david.lua")
HODGE.load_script("objects/jokers/misc/blip.lua")
HODGE.load_script("objects/jokers/joke/jovialmerriment.lua")
HODGE.load_script("objects/jokers/misc/djungelskog.lua")

HODGE.load_script("objects/jokers/pokemon/umbreon.lua")
HODGE.load_script("objects/jokers/pokemon/missingno.lua")
HODGE.load_script("objects/jokers/pokemon/badegg.lua") -- does... does this count?
HODGE.load_script("objects/jokers/pokemon/eeeee.lua")
HODGE.load_script("objects/jokers/pokemon/runerigus.lua")

HODGE.load_script("objects/jokers/mlp/timeloop.lua") --this fucker is soooooo broken
HODGE.load_script("objects/jokers/mlp/flutterbat.lua")
HODGE.load_script("objects/jokers/mlp/celestia.lua") -- i moved celestia to be in the middle lol
HODGE.load_script("objects/jokers/mlp/cheesesandwich.lua")
HODGE.load_script("objects/jokers/mlp/foreverweedbrownie.lua")

HODGE.load_script("objects/jokers/joke/bluelatro.lua")
-- Page 5 - UTDR
-- HODGE.load_script("objects/jokers/utdr/prophecy.lua")

------ Crossmod ------
HODGE.load_script("objects/jokers/fusions/suncleric.lua")
HODGE.load_script("objects/jokers/fusions/moonrogue.lua")
HODGE.load_script("objects/jokers/fusions/cockncat.lua")
HODGE.load_script("objects/jokers/fusions/snakemerchant.lua")
HODGE.load_script("objects/jokers/fusions/laddervizier.lua")

HODGE.load_script("objects/jokers/fusions/twishy.lua")
HODGE.load_script("objects/jokers/fusions/immoralimmortal.lua")
HODGE.load_script("objects/jokers/fusions/cheesepie.lua")
HODGE.load_script("objects/jokers/fusions/bluestopsign.lua")
HODGE.load_script("objects/jokers/fusions/neverpunished.lua")


HODGE.load_script("objects/jokers/misc/deceitfuljoker.lua")
HODGE.load_script("objects/jokers/misc/covetousjoker.lua")
HODGE.load_script("objects/jokers/misc/snakesandladders.lua")
HODGE.load_script("objects/jokers/misc/jade.lua")
HODGE.load_script("objects/jokers/misc/amethyst.lua")

------ Blinds ------
HODGE.load_script("objects/blinds/name.lua") -- I CURSE THE NAME THE ONE BEHIND IT ALLLLLLLLLLLLLLLLLLLLLLL
HODGE.load_script("objects/blinds/pip.lua") -- who up tipping they pip

------ Challenges ------
HODGE.load_script("objects/challenges/battleroyale.lua")
HODGE.load_script("objects/challenges/timeline.lua")

------ Rarities ------
--HODGE.load_script("objects/rarities/ubiquitous.lua")

------ Tags ------
HODGE.load_script("objects/tags/assist.lua")
HODGE.load_script("objects/tags/power.lua")
HODGE.load_script("objects/tags/clue.lua")
HODGE.load_script("objects/tags/star.lua")
HODGE.load_script("objects/tags/clover.lua")

HODGE.load_script("collabs/mlp.lua")


SMODS.Shader {
    key = "blue",
    path = "blue.fs"
}