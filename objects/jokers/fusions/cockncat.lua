if FusionJokers then

    SMODS.Joker {
        key = "cockncat",
        loc_vars = function (self,info_queue,card)
            return {
                vars = {
                    card.ability.extra.hands,card.ability.d_size,card.ability.extra.hand_size
                }
            }
        end,
        config = {
            d_size = 2,
            extra = {
                hands = 2,
                hand_size = 2
            }
        },
        atlas = "jokers_atlas",
        pos = {x=0,y=HODGE.atlas_y.misc[1]},
        rarity = "fuse_fusion",
        cost = 12,
        calculate = function(self,card,context)

        end,
        blueprint_compat = true,
        set_badges = function(self,card,badges)
            badges[#badges+1] = HODGE.badge('category','joke')
        end,
        add_to_deck = function(self,card,from_debuff)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
            G.hand:change_size(card.ability.extra.hand_size)
        end,
        remove_from_deck = function(self,card,from_debuff)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
            G.hand:change_size(-card.ability.extra.hand_size)
        end,
    }

    FusionJokers.fusions:register_fusion{
        jokers = {
            { name = "j_hodge_cocksley" },
            { name = "j_hodge_catapult" }
        },
        result_joker = "j_hodge_cockncat",
        cost = 12
    }
    
else
    HODGE.fake_locked_joker("cockncat","fusionjokers")
end