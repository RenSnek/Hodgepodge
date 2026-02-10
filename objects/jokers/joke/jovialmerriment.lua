SMODS.Joker {
    key = "jovialmerriment",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.dollars,
                -- card.ability.extra.xmult_gain,
                -- card.ability.extra.scaling_xmult,
                G.GAME.round_scores.hand.amt
            }
        }
    end,
    config = {
        extra = {
            -- scaling_xmult = 1,
            -- xmult_gain = 0.5,
            dollars = 20
        }
    },
    atlas = "jokers_atlas",
    pos = {x=3,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=3,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.after and context.cardarea == G.jokers and not context.blueprint then
            if hand_chips * mult >= G.GAME.round_scores.hand.amt then
                -- card.ability.extra.scaling_xmult = card.ability.extra.scaling_xmult + card.ability.extra.xmult_gain
                return {
                    -- message = "+"..card.ability.extra.xmult_gain.."X"
                    dollars = card.ability.extra.dollars
                }
            end
        end
        -- if context.joker_main then
        --     return {xmult = card.ability.extra.scaling_xmult}
        -- end
    end,
    blueprint_compat = true,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','joke')
    end
}
