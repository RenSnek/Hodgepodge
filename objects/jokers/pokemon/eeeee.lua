SMODS.Joker {
    key = "eeeee",
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.xmult_gain,
                card.ability.extra.scaling_xmult
            }
        }
    end,
    config = {
        extra = {
            scaling_xmult = 1,
            xmult_gain = 0.5
        }
    },
    atlas = "jokers_atlas",
    pos = {x=8,y=HODGE.atlas_y.legendary[1]},
    soul_pos = {x=8,y=HODGE.atlas_y.soul[5]},
    rarity = 4,
    cost = 20,
    calculate = function(self,card,context)
        if context.hodge_rank_change and not context.blueprint then
            local num_orig_rank = SMODS.Ranks[tostring(context.orig_rank)].id
            local num_new_rank = SMODS.Ranks[tostring(context.new_rank)].id
            print(context.num_orig_rank,  context.num_new_rank)
            if context.num_orig_rank < context.new_rank then
                card.ability.extra.scaling_xmult = card.ability.extra.scaling_xmult + card.ability.extra.xmult_gain
                return {
                    message = "+"..card.ability.extra.xmult_gain.."X"
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.scaling_xmult
            }
        end
    end,
    blueprint_compat = true,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','pokemon')
    end
}
