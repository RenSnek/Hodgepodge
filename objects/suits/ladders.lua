SMODS.Suit {
    key = "ladders",
    card_key = "LADDERS",
    pos = {y=1},
    ui_pos = {x=1,y=0},
    lc_atlas = 'suits_atlas',
    hc_atlas = 'suits_atlas',
    lc_ui_atlas = 'icons_atlas',
    hc_ui_atlas = 'icons_atlas',
    lc_colour = HEX("BB17F2"),
    hc_colour = HEX("BB17F2"),
    in_pool = function(self,args)
        if G.GAME.selected_back then
            local ladder_decks = {"Board Game Deck"}
            local ladder_sleeves = {"sleeve_hodge_boardgame"}
            return HODGE.table_contains(ladder_decks,G.GAME.selected_back.name) or HODGE.table_contains(ladder_sleeves,G.GAME.selected_sleeve)
        else
            return true
        end
    end
}

-- SMODS.DeckSkin {
--     key = "mlp_ladders",
--     suit = "hodge_ladders",
--     palettes = {
--         {
--             key = 'lc',
--             ranks = {2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"},
--             display_ranks = {"King","Queen","Jack"},
--             atlas = "hodge_modded_mlp_suits_atlas",
--             pos_style = "deck",
--             colour = HEX("21A888"),
--             suit_icon = {
--                 atlas = "hodge_icons_atlas",
--                 pos = {x=1,y=0}
--             }
--         },
--         {
--             key = 'lc_con',
--             ranks = {2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"},
--             display_ranks = {"King","Queen","Jack"},
--             atlas = "hodge_modded_mlp_suits_2_atlas",
--             pos_style = "deck",
--             colour = HEX("21A888"),
--             suit_icon = {
--                 atlas = "hodge_icons_atlas",
--                 pos = {x=1,y=0}
--             }
--         }
--     },
--     -- loc_txt = "My Little Pony"
-- }