SMODS.Joker {
    key = "placeholder",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {}
        }
    end,
    config = {
    },
    atlas = "jokers_atlas",
    pos = {x=0,y=HODGE.atlas_y.misc[1]},
    rarity = 1,--"hodge_ubiquitous",
    cost = 1,
    blueprint_compat = false,
    calculate = function(self,card,context)
    end,
    add_to_deck = function(self,card,from_debuff) 
        local jokers = {}
        for k,v in pairs(G.P_CENTER_POOLS.Joker) do
            if v.mod and v.mod.id == "hodge" and v.key ~= "j_hodge_placeholder" then
                if not jokers[v.rarity] then
                    jokers[v.rarity] = {}
                end
                jokers[v.rarity][#jokers[v.rarity] + 1] = v.key
            end
        end
        -- print(jokers)
        local rarity_weights = {
            [1] = 0.70, --Common:   70% (Vanilla: 70%)
            [2] = 0.95, --Uncommon: 25% (Vanilla: 25%)
            [3] = 0.99, --Rare:      4% (Vanilla:  5%)
            [4] = 1     --Legendary: 1% (Vanilla: N/A)
        }
        local rand = pseudorandom("placeholder")
        local chosen_rarity = 1
        for rarity,weight in pairs(rarity_weights) do
            if rand < weight and rand > rarity_weights[chosen_rarity] then
                chosen_rarity = rarity
            end
        end
        -- print(rand,chosen_rarity)
        local chosen_joker = pseudorandom_element(jokers[chosen_rarity],"placeholder")
        G.E_MANAGER:add_event(Event({
            func = function() 
                card:start_dissolve(nil, nil, 1.6)
                local new_card = create_card('Joker', G.jokers, nil, 0, nil, nil, chosen_joker, "placeholder")
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
                -- new_card:set_edition({["negative"] = true}, true)
                new_card:start_materialize()
                return true
            end}))

        -- card.added_to_deck = false
        -- for i=1,20 do 
        --     G.E_MANAGER:add_event(Event({func = function()
        --         local rand = pseudorandom("placeholder")
        --         local chosen_rarity = 1
        --         for rarity,weight in pairs(rarity_weights) do
        --             if rand < weight and rand > rarity_weights[chosen_rarity] then
        --                 chosen_rarity = rarity
        --             end
        --         end
        --         -- print(rand,chosen_rarity)
        --         local chosen_joker = pseudorandom_element(jokers[chosen_rarity],"placeholder")
        --         card:set_ability(G.P_CENTERS[chosen_joker],nil,nil)
        --         card:juice_up(0.3, 0.5)
        --         print(((i^1.5)/50.0)+0.2)
        --         return true end}))
        --     delay(((i^1.5)/75.0)+0.2)
        -- end
        -- G.E_MANAGER:add_event(Event({func = function()
        --     local rand = pseudorandom("placeholder")
        --     local chosen_rarity = 1
        --     for rarity,weight in pairs(rarity_weights) do
        --         if rand < weight and rand > rarity_weights[chosen_rarity] then
        --             chosen_rarity = rarity
        --         end
        --     end
        --     -- print(rand,chosen_rarity)
        --     local chosen_joker = pseudorandom_element(jokers[chosen_rarity],"placeholder")
        --     card.added_to_deck = true
        --     card:set_ability(G.P_CENTERS[chosen_joker],nil,nil)
        --     card:juice_up(0.3, 0.5)
        --     return true end}))
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','misc')
    end
}