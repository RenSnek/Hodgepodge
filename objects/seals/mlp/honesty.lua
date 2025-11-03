SMODS.Seal {
    key = "honesty",
    badge_colour = HEX("FEB55E"),
    config = {
        extra = {
            card_positions = {"?","?","?"},
            card_elements = {"?","?","?"}
        }
    },
    -- loc_txt = {
    --     label = "Element of Harmony",
    --     name = "Element of Honesty",
    --     text = {
    --         "Reveals the positions of",
    --         "up to {C:attention}3{} upcoming",
    --         "{C:attention}Elements of Harmony{}:",
    --         "{C:attention,s:0.8}#1#{s:0.8} - {C:attention,s:0.8}#2#{s:0.8} cards{}",
    --         "{C:attention,s:0.8}#3#{s:0.8} - {C:attention,s:0.8}#4#{s:0.8} cards{}",
    --         "{C:attention,s:0.8}#5#{s:0.8} - {C:attention,s:0.8}#6#{s:0.8} cards{}",
    --     }
    -- },
    loc_vars = function(self,info_queue,card)
        -- print("card.ability.seal:")
        -- print(card.ability.seal)
        -- print("self.ability:")
        -- print(self.ability)

        local card_elements = {}
        local card_positions = {}

        if card.area == G.hand then
            local element_names = {
                hodge_honest = "Honesty",
                hodge_laughter = "Laughter",
                hodge_magic = "Magic",
                hodge_loyalty = "Loyalty",
                hodge_generosity = "Generosity",
                hodge_kindness = "Kindness"
            }
            
            local check_deck = {}
            for k,v in ipairs(G.deck.cards) do -- Reverse the deck
                table.insert(check_deck,1,v)
            end
            for i,v in ipairs(check_deck) do
                if HODGE.table_true_size(card_elements) < 3 then
                    if HODGE.table_contains(HODGE.elements_of_harmony,v.seal) then
                        table.insert(card_elements,element_names[v.seal])
                        table.insert(card_positions,tostring(i))
                    end
                end
            end
            while HODGE.table_true_size(card_elements) < 3 do
                table.insert(card_elements,"?")
                table.insert(card_positions,"?")
            end
        else
            card_elements = {"?","?","?"}
            card_positions = {"?","?","?"}
        end

        return {vars = {
            card_elements[1],card_positions[1],
            card_elements[2],card_positions[2],
            card_elements[3],card_positions[3],
        }}

        -- return {vars = ((card and card.ability and card.ability.seal and card.ability.seal.extra and card.ability.seal.extra.card_elements) and {
        --     card.ability.seal.extra.card_elements[1], card.ability.seal.extra.card_positions[1],
        --     card.ability.seal.extra.card_elements[2], card.ability.seal.extra.card_positions[2],
        --     card.ability.seal.extra.card_elements[3], card.ability.seal.extra.card_positions[3]
        -- }) or {"?","?","?","?","?","?"}}
    end,
    calculate = function(self, card, context)
        -- if context.cardarea == G.hand then
        --     card.ability.seal.extra.card_elements = {}
        --     card.ability.seal.extra.card_positions = {}

        --     local element_names = {
        --         hodge_honest = "Honesty",
        --         hodge_laughter = "Laughter",
        --         hodge_magic = "Magic",
        --         hodge_loyalty = "Loyalty",
        --         hodge_generosity = "Generosity",
        --         hodge_kindness = "Kindness"
        --     }
            
        --     local check_deck = {}
        --     for k,v in ipairs(G.deck.cards) do -- Reverse the deck
        --         table.insert(check_deck,1,v)
        --     end
        --     for i,v in ipairs(check_deck) do
        --         if HODGE.table_true_size(card.ability.seal.extra.card_elements) < 3 then
        --             if HODGE.table_contains(HODGE.elements_of_harmony,v.seal) then
        --                 table.insert(card.ability.seal.extra.card_elements,element_names[v.seal])
        --                 table.insert(card.ability.seal.extra.card_positions,tostring(i))
        --             end
        --         end
        --     end
        --     while HODGE.table_true_size(card.ability.seal.extra.card_elements) < 3 do
        --         table.insert(card.ability.seal.extra.card_elements,"?")
        --         table.insert(card.ability.seal.extra.card_positions,"?")
        --     end
        -- else
        --     card.ability.seal.extra.card_elements = {"?","?","?"}
        --     card.ability.seal.extra.card_positions = {"?","?","?"}
        -- end
    end,
    atlas = "seal_atlas",
    pos = {x=2,y=1}
}

-- The effect is carried out in hooks/general.lua