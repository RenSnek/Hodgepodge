SMODS.Suit {
    key = "snake",
    card_key = "SNAKE",
    pos = {y=0},
    ui_pos = {x=0,y=0},
    -- loc_txt = {
    --     singular = "Snake",
    --     plural = "Snakes"
    -- },
    lc_atlas = 'suits_atlas',
    hc_atlas = 'suits_atlas',
    lc_ui_atlas = 'icons_atlas',
    hc_ui_atlas = 'icons_atlas',
    lc_colour = HEX("21A888"),
    hc_colour = HEX("21A888"),
    in_pool = function(self,args)
        if G.GAME.selected_back then
            local snake_decks = {"Board Game Deck"}
            local snake_sleeves = {"sleeve_hodge_boardgame"}
            return HODGE.table_contains(snake_decks,G.GAME.selected_back.name) or HODGE.table_contains(snake_sleeves,G.GAME.selected_sleeve)
        else
            return true
        end
    end
}

SMODS.DeckSkin {
    key = "mlp_snake",
    suit = "hodge_snake",
    palettes = {
        {
            key = 'lc',
            ranks = {2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"},
            display_ranks = {"King","Queen","Jack"},
            atlas = "hodge_modded_mlp_suits_atlas",
            pos_style = "deck",
            colour = HEX("21A888"),
            suit_icon = {
                atlas = "hodge_icons_atlas",
                pos = {x=0,y=0}
            }
        },
        {
            key = 'lc_con',
            ranks = {2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"},
            display_ranks = {"King","Queen","Jack"},
            atlas = "hodge_modded_mlp_suits_2_atlas",
            pos_style = "deck",
            colour = HEX("21A888"),
            suit_icon = {
                atlas = "hodge_icons_atlas",
                pos = {x=0,y=0}
            }
        }
    },
    -- loc_txt = "My Little Pony"
}