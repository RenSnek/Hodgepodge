SMODS.Joker {
    key = "lumi",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {}
        }
    end,
    config = {
        extra = {
            slime_floor = 2
        }
    },
    atlas = "jokers_atlas",
    pos = {x=0,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=0,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    blueprint_compat = false,
    calculate = function(self,card,context)
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','misc')
    end
}

