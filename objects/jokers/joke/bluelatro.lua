SMODS.Joker {
    key = "bluelatro",
    loc_vars = function (self,info_queue,card)
        return {
        }
    end,
    config = {
        extra = {
            chip_gain_mult = 2 -- multiply all chip gain by 2
        }
    },
    atlas = "jokers_atlas",
    pos = {x=0,y=HODGE.atlas_y.joke[2]},
    rarity = 1,
    cost = 1,
    blueprint_compat = false,
    no_collection = true,
    calculate = function(self,card,context)
    end,
    add_to_deck = function(self,card,from_debuff)
        G.GAME.hodge_blue = true
    end,
    remove_from_deck = function(self,card,from_debuff)
        G.GAME.hodge_blue = (#SMODS.find_card("j_hodge_bluelatro") > 0)
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','joke')
    end
}

