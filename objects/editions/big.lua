SMODS.Shader {
    key = "big",
    path = "big.fs"
}

SMODS.Sound {
    key = "spawn_big",
    path = "sfx_spawn_big.ogg"
}

SMODS.Edition {
    key = "big",
    shader = "big", -- Big shader currently doesn't do anything, as scale is handled in on_apply, on_load, etc.
    -- loc_txt = {
    --     label = "Big",
    --     name = "Big",
    --     text = {
    --         "Takes {C:dark_edition}2{} #1#",
    --         "{C:attention}Doubles{} all* values",
    --         "{s:0.8,C:inactive}*Where possible"
    --     }
    -- },
    loc_vars = function(self, info_queue, card)
        if card and card.ability then
            if card.ability.set == "Joker" or card.ability.set == "Edition" then --"Edition" for the collection menu
                return {vars = {"Joker slots"}}
            elseif card.ability.set == "Default" then
                return {vars = {"hand size"}}
            else -- Each consumable has a different card.ability.set so im just taking a gamble here
                return {vars = {"consumable slots"}}
            end
        else
            return {vars = {"card slots"}}
        end
    end,
    config = {
        card_limit = -1
    },
    sound = {sound = "hodge_spawn_big", per = 1, vol = 0.6},
    in_shop = true,
    weight = 10,
    get_weight = function(self)
        -- if G.GAME.selected_back.name == "Jumbo Deck" then
        --     return true
        -- end
        return G.GAME.edition_rate * self.weight
    end,
    extra_cost = 5,
    apply_to_float = true,
    disable_base_shader = true,
    on_apply = function(card) -- WHEN A CARD BECOMES BIG
        ----print("Checking to apply Big! orig mult = "..card.hodge_orig_ability.mult)
        -- if not card.hodge_upgrade_big then
            ----print("Applying Big! orig mult = "..card.hodge_orig_ability.mult)
            -- local extra_probability_jokers = {"8 Ball","Business Card","Space Joker"} -- List of jokers who have ability.extra set to just 1 number, the probability of smth happening
            -- local extra_is_probability = HODGE.table_contains(extra_probability_jokers,card.ability.name) -- If current joker is one of these jokers ^^^
            -- ----print(card.ability.mult)
            
            -- local ignore_keys = {
            --     ["cry_prob"] = true, ["akyrs_cycler"] = true, -- cryptid probability, aiko's cycling card (hibana i think)
            --     ["odds"] = true, -- Multiplying odds by 2 makes them half as likely! I want them to be twice as likely,
            --     ["extra"] = extra_is_probability -- ^
            -- } 

            -- if card and card.ability and card.ability.extra and type(card.ability.extra) == "table" and card.ability.extra.hodge_big_ignore then
            --     for k,v in pairs(card.ability.extra.hodge_big_ignore) do
            --         ignore_keys[k] = v
            --     end
            -- end

            -- HODGE.mod_card_values(card.ability,{multiply = 2, reference = card.hodge_orig_ability, unkeywords = ignore_keys})
            -- ----print(card.ability.mult)
            -- HODGE.mod_card_values(card.ability,{multiply = 0.5, keywords = {["odds"]=true,["extra"]=extra_is_probability,["cry_prob"]=true}}) -- Multiply just the odds
            -- ----print(card.ability.mult)
            -- card.hodge_upgrade_big = true


        -- ^^ old implementation. we use blockbuster now
        Blockbuster.manipulate_value(card,"hodge_big",2)

        card.T.scale = card.T.scale * 1.25
            ----print("Applied Big! orig mult = "..card.hodge_orig_ability.mult)
        -- end
        
        --card.role.draw_major.T.w = card.role.draw_major.T.w * 1.25
        --card.role.draw_major.T.h = card.role.draw_major.T.h * 1.25
    end,
    on_remove = function(card) -- REMOVING BIG FROM A CARD
        ----print("Removing Big! orig mult = "..tostring(card.hodge_orig_ability.mult))
        -- card.ability = HODGE.deep_copy(card.hodge_orig_ability)
        -- card.hodge_upgrade_big = false
        Blockbuster.manipulate_value(card,"hodge_big",1)
        card.T.scale = card.T.scale / 1.25
        ----print("Removed Big! orig mult = "..card.hodge_orig_ability.mult)
        --card.role.draw_major.T.w = card.role.draw_major.T.w / 1.25
        --card.role.draw_major.T.h = card.role.draw_major.T.h / 1.25
    end,
    on_load = function(card) -- LOADING A SAVE WITH A BIG CARD
        card.T.scale = card.T.scale * 1.25
        --card.role.draw_major.T.w = card.role.draw_major.T.w * 1.25
        --card.role.draw_major.T.h = card.role.draw_major.T.h * 1.25
    end
}