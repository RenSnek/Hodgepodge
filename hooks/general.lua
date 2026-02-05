-- Give cards the attribute "hodge_upgrade_big" for storing whether or not they are big
local cardInitHook = Card.init
function Card:init(X,Y,W,H,card,center,params)
    local ret = cardInitHook(self,X,Y,W,H,card,center,params)
    self.hodge_upgrade_big = false
    return ret
end-- Store a card's original ability, so that if it's changed (e.g. by the Big edition) it can be reverted
-- P.S: This is also lifted from Aikoyori's Shenanigans
local setCardAbilityHook = Card.set_ability
function Card:set_ability(c,i,d)
    local r = setCardAbilityHook(self,c,i,d)
    if (i) then
        self.hodge_orig_ability = HODGE.deep_copy(self.ability)
    end
    return r
end

-- Save/Load the custom attributes given to a card
local cardSave = Card.save
function Card:save()
    local c = cardSave(self)
    c.hodge_orig_ability = self.hodge_orig_ability
    c.hodge_upgrade_big = self.hodge_upgrade_big
    return c
end

local cardLoad = Card.load
function Card:load(cardTable,other_card)
    local c = cardLoad(self,cardTable,other_card)
    self.hodge_orig_ability = cardTable.hodge_orig_ability
    self.hodge_upgrade_big = cardTable.hodge_upgrade_big
    return c
end


-- -- THIS IS NO LONGER ITS EFFECT - Element of Honesty cannot be flipped
-- local blindStayFlipped = Blind.stay_flipped
-- function Blind:stay_flipped(area,card,from_area)
--     local r = blindStayFlipped(self,area,card,from_area)
--     if card and card.seal == "hodge_honesty" then
--         return false
--     else
--         return r
--     end
-- end

-- Element of Laughter Retriggers other elements
local calculateSeal = Card.calculate_seal
function Card:calculate_seal(context)
    local ret = calculateSeal(self,context)
    if context.repetition then
        if context.scoring_hand and HODGE and HODGE.table_contains and HODGE.table_contains(HODGE.elements_of_harmony,self.seal) then
            for k,v in ipairs(context.scoring_hand) do
                if v.seal == "hodge_laughter" and v ~= self then
                    return {
                        message = "Haha!",
                        repetitions = 1,
                        card = self
                    }
                end
            end
        end
    end
    return ret
end

-- Menu card
local menuHook = Game.main_menu
function Game:main_menu(ctx)
    local r = menuHook(self,ctx)
    local card_faces = {"hodge_SUNS_A","hodge_MOONS_A","hodge_SNAKE_A","hodge_LADDERS_A"}
    local card_face = card_faces[math.random(#card_faces)]
    local card_enhancements = {"m_hodge_asbestos","m_hodge_blackhole","m_hodge_waterdamage"}
    local card_enhancement = card_enhancements[math.random(#card_enhancements)]
    local card = Card(0,0,G.CARD_W,G.CARD_H,G.P_CARDS[card_face],G.P_CENTERS[card_enhancement])
    card.T.w = card.T.w * 1.4
    card.T.h = card.T.h * 1.4
    G.title_top.T.w = G.title_top.T.w * 1.7675
    G.title_top.T.x = G.title_top.T.x - 0.8
    card:set_sprites(card.config.center)
    card.no_ui = true
    card.states.visible = false
    self.title_top:emplace(card)
    G.E_MANAGER:add_event(
        Event{
            delay = 0.5,
            func = function()
                if ctx == "splash" then
                    card.states.visible = true
                    card:start_materialize({G.C.WHITE, G.C.WHITE}, true, 2.5)
                else
                    card.states.visible = true
                    card:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.2)
                end
                return true
            end
        }
    )
    return r
end

-- Clicking context
local cardClick = Card.click
function Card:click()
    if self.area and self.area == G.jokers then
        SMODS.calculate_context({hodge_clicked = true, card_clicked = self})
    end
    local ret = cardClick(self)
    return ret
end

-- Card change contexts

local setBase = Card.set_base
function Card:set_base(card,initial,manual_sprites)
    --print(card and card.value)
    --print(self and self.base and self.base.value)
    if (self and self.base and self.base.suit) and (card and card.suit) and self.base.suit ~= card.suit then
        --print("suit change")
        SMODS.calculate_context({hodge_suit_change = true, other_card = self, orig_suit = self.base.suit, new_suit = card.suit})
    end
    if (self and self.base and self.base.value) and (card and card.value) and self.base.value ~= card.value then
        --print("rank change")
        SMODS.calculate_context({hodge_rank_change = true, other_card = self, orig_rank = self.base.value, new_rank = card.value})
    end
    
    ret = setBase(self,card,initial,manual_sprites)
    return ret
end

local get_blind_amount_orig = get_blind_amount
get_blind_amount = function(ante)
    if G.GAME and G.GAME.hodge_use_scoring_ante and G.GAME.hodge_use_scoring_ante > 0 and G.GAME.hodge_scoring_ante ~= nil then
        return get_blind_amount_orig(G.GAME.hodge_scoring_ante)
    else
        return get_blind_amount_orig(ante)
    end
end

-- Vest Up chip gain, hodge_partial_balance
local orig_calculate_individual_effect = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    if (key == 'chips' or key == 'h_chips' or key == 'chip_mod') and amount then

        --print("--- "..scored_card.ability.name.." ---")
        --print(effect)
        --print("Before: "..amount)
        local bonus_chips = 0
        local bonus_chip_mult = 1
        for k,joker in pairs(G.jokers.cards) do
            if joker.ability.name == "j_hodge_vestup" then
                bonus_chips = bonus_chips + joker.ability.extra.chip_gain_bonus
                --print("New bonus: "..bonus_chips.." | Gained "..joker.ability.extra.chip_gain_bonus)
                joker:juice_up()
            end
            if joker.ability.name == "j_hodge_bluelatro" then
                bonus_chip_mult = bonus_chip_mult * joker.ability.extra.chip_gain_mult
                joker:juice_up()
            end
        end

        local orig_amount = amount
        amount = (amount + bonus_chips) * bonus_chip_mult
        --print("After: "..amount)


        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
        hand_chips = mod_chips(hand_chips + amount)
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
        if not effect.remove_default_message then
            if from_edition then
                --print("from_edition")
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type = 'variable', key = amount > 0 and 'a_chips' or 'a_chips_minus', vars = {amount}}, chip_mod = amount, colour = G.C.EDITION, edition = true})
            else
                if key ~= 'chip_mod' then
                    --print("~= chip_mod")
                    if effect.chip_message then
                        --print("effect.chip_message")
                        --print(effect.chip_message)
                        card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.chip_message)
                    else
                        --print("No effect.chip_message")
                        card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'chips', amount, percent)
                    end
                else
                    --print("No card_eval_status_text ran")
                    if effect.message then --this is all custom
                        effect.message = effect.message:gsub(orig_amount,amount)
                    end
                end
            end
        end
        return true
    end

    local ret = orig_calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    if ret ~= nil then
        return ret
    end

    if key == 'hodge_partial_balance' then
        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
        local total = mult + hand_chips
        mult = mod_mult(((1-amount)*mult) + (amount*(total/2)))
        hand_chips = mod_chips(((1-amount)*hand_chips) + (amount*(total/2)))
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
        G.E_MANAGER:add_event(Event({
            func = (function()
                -- scored_card:juice_up()
                play_sound('gong', 0.94, 0.3)
                play_sound('gong', 0.94*1.5, 0.2)
                play_sound('tarot1', 1.5)
                ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    delay =  0.8,
                    func = (function() 
                            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
                            ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
                        return true
                    end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    no_delete = true,
                    delay =  1.3,
                    func = (function() 
                        G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                        G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                        return true
                    end)
                }))
                return true
            end)
        }))
        if not effect.remove_default_message then
            if effect.balance_message then
                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.balance_message)
            else
                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, {message = localize('k_balanced'), colour =  {0.8, 0.45, 0.85, 1}})
            end
        end
        delay(0.6)

        return true
    end
end