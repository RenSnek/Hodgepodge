SMODS.Joker {
    key = "badegg",
    -- loc_txt = {
    --     name = "Bad EGG",
    --     text = {
    --         "{C:dark_edition,E:1,s:1.5}...{}"
    --     }
    -- },
    loc_vars = function (self,info_queue,card)
        return {vars = {}}
    end,
    config = {
    },
    atlas = "jokers_atlas",
    pos = {x=7,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=7,y=HODGE.atlas_y.soul[5]},
    rarity = 3,
    cost = -10,
    in_pool = function(self,args)
        return false
    end,
    calculate = function(self,card,context)
        if context.setting_blind and not context.blueprint then
            if pseudorandom("bad_egg") < 1/255 then
                local legendary = pseudorandom_element(G.P_JOKER_RARITY_POOLS[4],pseudoseed("bad_egg"))
                
                local c = (context.blueprint and context.blueprint_card) or card
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    --print("flip down")
                    c:flip()
                    play_sound('card1')
                    c:juice_up(0.3,0.3)
                    return true end }))
                delay(0.2)
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                    --print("set ability")
                    c:set_ability(legendary)
                    return true end }))
                delay(0.1)
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                    --print("flip up")
                    if c.facing == "back" then c:flip() end
                    play_sound('card1')
                    c:juice_up(0.3,0.3)
                    return true end }))
                return {
                    message = "Hatched!"
                }
            else
                return {
                    message = "Oh?"
                }
            end
        end
    end,
    blueprint_compat = false,
    -- add_to_deck = function(self,card,from_debuff)
    --     card.sell_cost = -256
    -- end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','pokemon?')
    end
}
