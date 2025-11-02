SMODS.Shader {
    key = "lenticular",
    path = "lenticular.fs"
}

-- SMODS.Sound {
--     key = "spawn_lenticular",
--     path = "sfx_spawn_lenticular.ogg"
-- }

HODGE.lenticular_images = {}
HODGE.lenticular_image_keys = {}
for i = 1,13 do
    HODGE.lenticular_images[string.format("img_%02d", i)] = HODGE.load_custom_image(string.format("lenticular/%02d.png", i))
    table.insert(HODGE.lenticular_image_keys,string.format("img_%02d", i))
end

SMODS.Edition {
    key = "lenticular",
    shader = "lenticular",
    loc_vars = function(self, info_queue, card)
        local vals = self.config
        if (card.edition and card.edition.extra) then
            vals = card.edition
        end
        return {vars = {vals.extra.balance * 100}}
    end,
    config = {
        extra = {
            balance = 0.2,
            image = nil,
        }
    },
    --sound = {sound = "hodge_spawn_lenticular", per = 1, vol = 0.6},
    in_shop = true,
    weight = 10,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    extra_cost = 5,
    apply_to_float = false,
    disable_base_shader = true,
    calculate = function(self, card, context)
        if (context.main_scoring and context.cardarea == G.play) or context.post_joker then
            local balance_chips = ((1-card.edition.extra.balance)*hand_chips) + (card.edition.extra.balance*((hand_chips+mult)/2))
            local balance_mult = ((1-card.edition.extra.balance)*mult) + (card.edition.extra.balance*((hand_chips+mult)/2))
            
            local chips_diff = balance_chips - hand_chips 
            local mult_diff = balance_mult - mult
            
            return {
                chips = chips_diff,
                mult = mult_diff,
                message = "Balance!",
                colour = G.C.PURPLE,
                remove_default_message = true
            }
        end
    end,

    -- update = function(self,card,dt)
    --     print("a")
    --     G.SHADERS["hodge_lenticular"]:send("tilt",card.tilt_var.amt)
    --     if card.edition and card.edition.extra and card.edition.extra.image then
    --         G.SHADERS["hodge_lenticular"]:send("image",card.edition.extra.image)
    --     else
    --         G.SHADERS["hodge_lenticular"]:send("image",HODGE.lenticular_images.img_09)
    --     end
    -- end,

    draw = function(self,card,layer)
        G.SHADERS["hodge_lenticular"]:send("tilt",card.tilt_var.amt)
        if card.edition and card.edition.extra and card.edition.extra.image then
            G.SHADERS["hodge_lenticular"]:send("image",HODGE.lenticular_images[card.edition.extra.image])
        else
            G.SHADERS["hodge_lenticular"]:send("image",HODGE.lenticular_images.img_09)
        end
        card.children.center:draw_shader("hodge_lenticular", nil,card.ARGS.send_to_shader)
        if card.children.front then card.children.front:draw_shader("hodge_lenticular", nil,card.ARGS.send_to_shader) end
    end,

    on_apply = function(card)
        card.edition.extra.image = pseudorandom_element(HODGE.lenticular_image_keys, "lenticular_img")
    end
}