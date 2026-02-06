SMODS.Joker {
    key = "lostcount",
    -- loc_txt = {
    --     name = "Blown Away",
    --     text = {
    --         "If played hand contains a",
    --         "{C:attention}Straight{}, destroy highest",
    --         "scoring card and reduce",
    --         "blind by {C:attention}#1#%{}"
    --     }
    -- },
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
            }
        }
    end,
    config = {
        extra = {
        }
    },
    atlas = "jokers_atlas",
    pos = {x=8,y=HODGE.atlas_y.joke[1]},
    --soul_pos = {x=10,y=HODGE.atlas_y.soul[1]},
    rarity = 2,
    cost = 6,
    calculate = function(self,card,context)
        if context.before and not context.blueprint then
            local changed_cards = {}
            for i=1, #context.scoring_hand do
                if context.scoring_hand[i].base.nominal > 4 then
                    context.scoring_hand[i].hodge_orig_value = context.scoring_hand[i].base.value
                    local new_value = pseudorandom_element({2,3,4,5,6,7,8,9,10,11,12,13,14},"lostcount")
                    changed_cards[i] = new_value
                    if (new_value > 10 and new_value < 14) then
                        context.scoring_hand[i].base.nominal = 10
                        local face_ranks = {"Jack","Queen","King"}
                        context.scoring_hand[i].base.value = face_ranks[(new_value-10)]
                    elseif new_value == 14 then
                        context.scoring_hand[i].base.nominal = 11
                        context.scoring_hand[i].base.value = "Ace"
                    else
                        context.scoring_hand[i].base.nominal = new_value
                        context.scoring_hand[i].base.value = tostring(new_value)
                    end
                    context.scoring_hand[i].base.id = new_value
                    local percent = 1.15 - (i-0.999)/(#context.scoring_hand-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.scoring_hand[i]:flip();play_sound('card1', percent);context.scoring_hand[i]:juice_up(0.3, 0.3);return true end }))
                end
            end
            for i,rank in pairs(changed_cards) do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    local card = context.scoring_hand[i]
                    -- these next 2 lines are so that it can detect it as a rank increase. the value is increased before so that its scored correctly
                    card.base.value = card.hodge_orig_value
                    card.hodge_orig_value = nil
                    
                    if rank <= 10 then rank = tostring(rank)
                    elseif rank == 11 then rank = 'Jack'
                    elseif rank == 12 then rank = 'Queen'
                    elseif rank == 13 then rank = 'King'
                    elseif rank == 14 or rank == 1 then rank = 'Ace'
                    end
                    
                    assert(SMODS.change_base(card,nil,rank))
                return true end }))
            end  
            for i,rank in pairs(changed_cards) do
                local percent = 0.85 + (i-0.999)/(#context.scoring_hand-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.scoring_hand[i]:flip();play_sound('tarot2', percent, 0.6);context.scoring_hand[i]:juice_up(0.3, 0.3);return true end }))
            end
        end
    end,
    blueprint_compat = false,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','misc')
    end
}