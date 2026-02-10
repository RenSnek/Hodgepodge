SMODS.Joker {
    key = "umbreon",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.card_mult
            }
        }
    end,
    config = {
        extra = {
            card_mult = 10
        }
    },
    atlas = "jokers_atlas",
    pos = {x=5,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=5,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.after and not context.blueprint then
            for i=1, #context.full_hand do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                    if context.full_hand[i] then
                        context.full_hand[i]:flip();play_sound('card1', percent);
                        context.full_hand[i]:juice_up(0.3, 0.3);
                    end
                return true end }))
            end
            for i=1, #context.full_hand do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    if context.full_hand[i] then
                        local card = context.full_hand[i]                    
                        assert(SMODS.change_base(card,"hodge_moons"))
                    end
                return true end }))
            end  
            for i=1, #context.full_hand do
                local percent = 0.85 + (i-0.999)/(#context.full_hand-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                    if context.full_hand[i] then
                        context.full_hand[i]:flip()
                        play_sound('tarot2', percent, 0.6)
                        context.full_hand[i]:juice_up(0.3, 0.3)
                    end
                return true end }))
            end
        end
        if context.individual and context.cardarea == G.play and context.other_card:is_suit("hodge_moons") then
            return {
                mult = card.ability.extra.card_mult
            }
        end
    end,
    blueprint_compat = true,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','pokemon')
    end
}
