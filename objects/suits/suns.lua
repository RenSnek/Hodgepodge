SMODS.Suit {
    key = "suns",
    card_key = "SUNS",
    pos = {y=2},
    ui_pos = {x=2,y=0},
    -- loc_txt = {
    --     singular = "Sun",
    --     plural = "Suns"
    -- },
    lc_atlas = 'suits_atlas',
    hc_atlas = 'hodge_modded_mlp_suits_2_atlas',
    lc_ui_atlas = 'icons_atlas',
    hc_ui_atlas = 'icons_atlas',
    lc_colour = HEX("F2AE17"),
    hc_colour = HEX("F2AE17"),
    in_pool = function(self,args)
        if G.GAME.selected_back then
            local sun_decks = {"Friendship Deck"}
            local sun_sleeves = {"sleeve_hodge_friendship"}
            return HODGE.table_contains(sun_decks,G.GAME.selected_back.name) or HODGE.table_contains(sun_sleeves,G.GAME.selected_sleeve)
        else
            return true
        end
    end
}

-- G.COLLABS.colour_palettes.default_hodge_suns = {"lc","lc_con"}

-- SMODS.DeckSkin {
--     key = "mlp_suns",
--     suit = "hodge_suns",
--     palettes = {
--         {
--             key = 'lc',
--             ranks = {2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"},
--             display_ranks = {"King","Queen","Jack"},
--             atlas = "hodge_modded_mlp_suits_atlas",
--             pos_style = "deck",
--             colour = HEX("F2AE17"),
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
--             colour = HEX("F2AE17"),
--             suit_icon = {
--                 atlas = "hodge_icons_atlas",
--                 pos = {x=1,y=0}
--             }
--         }
--     },
--     -- loc_txt = "My Little Pony"
-- }