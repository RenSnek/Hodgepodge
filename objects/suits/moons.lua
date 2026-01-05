SMODS.Suit {
    key = "moons",
    card_key = "MOONS",
    pos = {y=3},
    ui_pos = {x=3,y=0},
    -- loc_txt = {
    --     singular = "Moon",
    --     plural = "Moons"
    -- },
    lc_atlas = 'suits_atlas',
    hc_atlas = 'hodge_modded_mlp_suits_2_atlas',
    lc_ui_atlas = 'icons_atlas',
    hc_ui_atlas = 'icons_atlas',
    lc_colour = HEX("5217F2"),
    hc_colour = HEX("5217F2"),
    in_pool = function(self,args)
        if G.GAME.selected_back then
            local moon_decks = {"Friendship Deck"}
            local moon_sleeves = {"sleeve_hodge_friendship"}
            return HODGE.table_contains(moon_decks,G.GAME.selected_back.name) or HODGE.table_contains(moon_sleeves,G.GAME.selected_sleeve)
        else
            return true
        end
    end
}

-- SMODS.DeckSkin {
--     key = "mlp_moons",
--     suit = "hodge_moons",
--     palettes = {
--         {
--             key = 'lc',
--             ranks = {2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"},
--             display_ranks = {"King","Queen","Jack"},
--             atlas = "hodge_modded_mlp_suits_atlas",
--             pos_style = "deck",
--             colour = HEX("5217F2"),
--             suit_icon = {
--                 atlas = "hodge_icons_atlas",
--                 pos = {x=2,y=0}
--             }
--         },
--         {
--             key = 'lc_con',
--             ranks = {2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"},
--             display_ranks = {"King","Queen","Jack"},
--             atlas = "hodge_modded_mlp_suits_2_atlas",
--             pos_style = "deck",
--             colour = HEX("5217F2"),
--             suit_icon = {
--                 atlas = "hodge_icons_atlas",
--                 pos = {x=2,y=0}
--             }
--         }
--     },
--     -- loc_txt = "My Little Pony"
-- }