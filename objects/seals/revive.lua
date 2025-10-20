SMODS.Seal {
    key = "revive",
    badge_colour = HEX("20D71D"),
    config = {
        extra = {
            copies = 1
        }
    },
    -- loc_txt = {
    --     label = "Revive",
    --     name = "Revive",
    --     text = {
    --         "Creates {C:attention}#1#{} copies of this",
    --         "card when {C:attention}destroyed{}"
    --     }
    -- },
    loc_vars = function(self,info_queue,card)
        return {vars = {(card.ability.seal or self.config).extra.copies}}
    end,
    atlas = "seal_atlas",
    calculate = function(self,card,context)
        if context.remove_playing_cards and HODGE.table_contains(context.removed,card) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _first_dissolve = nil
                    local new_cards = {}
                    for i = 1, self.config.extra.copies do
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local _card = copy_card(card, nil, nil, G.playing_card)
                        _card:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, _card)
                        G.hand:emplace(_card)
                        _card:start_materialize(nil, _first_dissolve)
                        _first_dissolve = true
                        new_cards[#new_cards+1] = _card
                    end
                    playing_card_joker_effects(new_cards)
                    return true
                end
            }))
        end
    end,
    pos = {x=0,y=0}
}
