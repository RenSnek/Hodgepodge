SMODS.Shader {
    key = "slime",
    path = "slime.fs"
}

SMODS.Sound {
    key = "spawn_slime",
    path = "sfx_spawn_slime.ogg"
}
SMODS.Sound {
    key = "trigger_slime_bad",
    path = "sfx_trigger_slime_bad.ogg"
}
SMODS.Sound {
    key = "trigger_slime_good",
    path = "sfx_trigger_slime_good.ogg"
}

SMODS.Edition {
    key = "terry",
    shader = "slime",
    -- loc_txt = {
    --     label = "Terry",
    --     name = "Terry",
    --     text = {
    --         "{X:mult,C:white}X#1#{} Mult",
    --         "{s:0.8,C:inactive}Randomly chosen when scored{}"
    --     }
    -- },
    loc_vars = function(self, info_queue, card)
        local vals = self.config
        --Check for lumi joker
        local lumi = false
        local lumi_val = 1
        if G.jokers and G.jokers.cards then
            for _,j in ipairs(G.jokers.cards) do
                if j.ability and j.ability.name == "j_hodge_lumi" then
                    lumi = true
                    if j.ability.extra.slime_floor > lumi_val then
                        lumi_val = j.ability.extra.slime_floor
                    end
                
                end 
            end
        end

        if (card.edition and card.edition.extra) then
            vals = card.edition
        end

        -- local rand = math.random()
        local inc = vals.extra.increment
        local min = lumi and lumi_val or vals.extra.lower_bound
        local max = vals.extra.upper_bound
        -- local placeholder = inc*math.ceil(((rand*(max-min))+min)/inc)

        local display_mults = {}
        for i = min, max+inc, inc do
            table.insert(display_mults,string.format("X%.1f",i))
        end
        local loc_mult = ' '..(localize('k_mult'))..' '
        local random_ui = {
                {n=G.UIT.C, config = {align = "m",colour = G.C.MULT,r = 0.05,padding = 0.03,res = 0.15}, 
                    nodes = {
                        {n=G.UIT.O, config={object = DynaText({string = display_mults, colours = {G.C.WHITE},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.3, scale = 0.32, min_cycle_time = 0})}},
                    }
                },
                {n=G.UIT.T, config={text = loc_mult, scale = 0.32, colour = G.C.UI.TEXT_DARK}},
            }


        return {vars = {}, main_start = random_ui}
    end,
    config = {
        extra = {
            lower_bound = 0.1,
            upper_bound = 3,
            increment = 0.1
        }
    },
    sound = {sound = "hodge_spawn_slime", per = 1, vol = 0.6},
    in_shop = true,
    weight = 10,
    get_weight = function(self)
        local lumis = 0
        for _,j in ipairs(G.jokers.cards) do
            if j.ability and j.ability.name == "j_hodge_lumi" then
                lumis = lumis + 1
            end 
        end
        return G.GAME.edition_rate * self.weight * (2^lumis)
    end,
    extra_cost = 4,
    apply_to_float = false,
    disable_base_shader = true,
    calculate = function(self, card, context)
        if (context.main_scoring and context.cardarea == G.play) or context.post_joker then
            --Check for lumi joker
            local lumi = false
            local lumi_val = 1
            for _,j in ipairs(G.jokers.cards) do
                if j.ability and j.ability.name == "j_hodge_lumi" then
                    lumi = true
                    if j.ability.extra.slime_floor > lumi_val then
                        lumi_val = j.ability.extra.slime_floor
                    end
               
                end 
            end
            --Behaviour
            local rand = math.random()
            local inc = card.edition.extra.increment
            local min = lumi and lumi_val or card.edition.extra.lower_bound
            local max = card.edition.extra.upper_bound
            local value = inc*math.ceil(((rand*(max-min))+min)/inc)
            local sound = nil
            if value > 1 then
                sound = "hodge_trigger_slime_good"
            elseif value < 1 then
                sound = "hodge_trigger_slime_bad"
            end
            return {x_mult = value, sound = sound, volume = 1.8, message = "X"..value.." Mult", remove_default_message = true, colour = G.C.DARK_EDITION}
        end
    end
}

