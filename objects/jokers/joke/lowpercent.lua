SMODS.Joker {
    key = "lowpercent",
    loc_vars = function (self,info_queue,card)
        local loc_chips = ' Chips' --' '..(localize('k_chips'))..' ' --There's no localisation for chips ??
        local ref = (card.area == G.jokers) and HODGE.lowpercent_vals or {[card.ability.extra.id_table] = 0}
        local live_update_ui = {
            -- {n=G.UIT.O, config={object = DynaText({ref_table = ref, ref_value = card.ability.extra.id_table, colours = {G.C.CHIPS},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.3, scale = 0.32, min_cycle_time = 0})}},
            {n=G.UIT.T, config={text = '+', scale = 0.32, colour = G.C.CHIPS}},
            {n=G.UIT.T, config={ref_table = ref, ref_value = card.ability.extra.id_table, scale = 0.32, colour = G.C.CHIPS}},
            {n=G.UIT.T, config={text = loc_chips, scale = 0.32, colour = G.C.UI.TEXT_DARK}},
            -- {n=G.UIT.O, config={object = DynaText({string = loc_chips, colours = {G.C.UI.TEXT_DARK},pop_in_rate = 9999999, silent = true, scale = 0.32})}}
        }
        return {
            vars = {card.ability.extra.scaling_chips,card.ability.extra.chip_gain},
            main_start = live_update_ui
        }
    end,
    config = {
        chips = 0,
        extra = {
            time_last_checked = nil,
            time_since_gain = 0,
            chip_gain = 0.25,
            scaling_chips = 0,
            id_table = {}, -- This is used to identify the table in HODGE.lowpercent_vals, as all tables are unique.
            big_ignore = {
                ["last_checked_time"] = true,
                ["time_since_gain"] = true,
                ["id_table"] = true
            }
        }
    },
    atlas = "jokers_atlas",
    pos = {x=4,y=HODGE.atlas_y.joke[1]},
    soul_pos = {x=4,y=HODGE.atlas_y.soul[3]},
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                chips = card.ability.extra.scaling_chips
            }
        end
    end,
    update = function(self, card, dt)
        if card.area == G.jokers then
            if card.ability.extra.last_checked_time then
                card.ability.extra.time_since_gain = card.ability.extra.time_since_gain + (G.TIMERS.REAL - card.ability.extra.last_checked_time)
                while card.ability.extra.time_since_gain >= 1 do
                    card.ability.extra.scaling_chips = card.ability.extra.scaling_chips + card.ability.extra.chip_gain
                    card.ability.extra.time_since_gain = card.ability.extra.time_since_gain - 1
                end
                if not HODGE.lowpercent_vals then
                    HODGE.lowpercent_vals = {}
                end
                HODGE.lowpercent_vals[card.ability.extra.id_table] = card.ability.extra.scaling_chips
            end
        end
        card.ability.extra.last_checked_time = G.TIMERS.REAL
    end,
    set_badges = function(self,card,badges)
        badges[#badges+1] = HODGE.badge('category','joke')
    end
}
