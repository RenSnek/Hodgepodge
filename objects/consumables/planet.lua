SMODS.Consumable {
    key = "avalon",
    set = "Planet",
    atlas = "tarot_atlas", pos = {x=0,y=0},
    -- loc_txt = {
    --     name = "Avalon",
    --     text = {
    --         "Upgrade {C:attention}least used{}",
    --         "poker hand by {C:attention}#1# levels{}",
    --         "and {C:attention}2nd least used{}",
    --         "poker hand by {C:attention}#2# levels{}",
    --     }
    -- },
    loc_vars = function (self,info_queue,card)
        return {vars = {
            card.ability.extra.upgrade_levels[1],
            card.ability.extra.upgrade_levels[2]
        }}
    end,
    config = {
        extra = {
            upgrade_levels = {5,3}
        }
    },
    in_pool = function(self,args)
        local highest_hand = ""
        local highest_use = nil
        local highest_value = nil
        for k,h in pairs(G.GAME.hands) do
            if (not highest_use) or (h.played > highest_use) or (h.played == highest_use and h.chips*h.mult > highest_value) then
                highest_hand = k
                highest_use = h.played
                highest_value = h.chips*h.mult
            end
        end

        local second_highest_hand = ""
        local second_highest_use = nil
        local second_highest_value = nil
        for k,h in pairs(G.GAME.hands) do
            if ((not second_highest_use) or (h.played > second_highest_use) or (h.played == second_highest_use and h.chips*h.mult > second_highest_value)) and k ~= highest_hand then
                second_highest_hand = k
                second_highest_use = h.played
                second_highest_value = h.chips*h.mult
            end
        end

        return (highest_use - second_highest_use >= 3)
    end,
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier) 
        local lowest_hand = ""
        local lowest_use = nil
        local lowest_value = nil
        for k,h in pairs(G.GAME.hands) do
            if (not lowest_use) or (h.played < lowest_use) or (h.played == lowest_use and h.chips*h.mult < lowest_value) then
                lowest_hand = k
                lowest_use = h.played
                lowest_value = h.chips*h.mult
            end
        end

        local second_lowest_hand = ""
        local second_lowest_use = nil
        local second_lowest_value = nil
        for k,h in pairs(G.GAME.hands) do
            if ((not second_lowest_use) or (h.played < second_lowest_use) or (h.played == second_lowest_use and h.chips*h.mult < second_lowest_value)) and k ~= lowest_hand then
                second_lowest_hand = k
                second_lowest_use = h.played
                second_lowest_value = h.chips*h.mult
            end
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=lowest_hand,chips = G.GAME.hands[lowest_hand].chips, mult = G.GAME.hands[lowest_hand].mult, level=G.GAME.hands[lowest_hand].level})
        level_up_hand(card, lowest_hand, false, card.ability.extra.upgrade_levels[1])
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})

        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=second_lowest_hand,chips = G.GAME.hands[second_lowest_hand].chips, mult = G.GAME.hands[second_lowest_hand].mult, level=G.GAME.hands[second_lowest_hand].level})
        level_up_hand(card, second_lowest_hand, false, card.ability.extra.upgrade_levels[2])
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end
}