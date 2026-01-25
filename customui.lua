-- CREDITS PAGE, code blatantly stolen from balatro goes kino

SMODS.current_mod.extra_tabs = function()
    local scale = 0.6
    return {
        label = localize("hodge_credits_header"),
        tab_definition_function = function()
            return {
                n = G.UIT.ROOT,
                config = {
                    align = "cm",
                    padding = 0.05,
                    colour = G.C.CLEAR
                },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = {
                            padding = 0,
                            align = "cl"
                        },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = {
                                    text = localize("hodge_credits_developer"),
                                    shadow = true,
                                    scale = scale * 0.8,
                                    colour = G.C.UI.TEXT_LIGHT
                                }
                            },
                            {
                                n = G.UIT.T,
                                config = {
                                    text = "PokéRen",
                                    shadow = true,
                                    scale = scale * 0.8,
                                    colour = G.C.BLUE
                                }
                            }
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = {
                            padding = 0,
                            align = "cl",
                        },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = {
                                    text = localize("hodge_credits_artists"),
                                    shadow = true,
                                    scale = scale * 0.8,
                                    colour = G.C.UI.TEXT_LIGHT
                                }
                            },
                            {
                                n = G.UIT.T,
                                config = {
                                    text = "PokéRen, Jorse/Radspeon, Pumpkin man, edward robinson",
                                    shadow = true,
                                    scale = scale * 0.8,
                                    colour = G.C.BLUE
                                }
                            }
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = {
                            padding = 0,
                            align = "cl",
                        },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = {
                                    text = localize("hodge_credits_thanks"),
                                    shadow = true,
                                    scale = scale * 0.8,
                                    colour = G.C.UI.BLUE
                                }
                            },
                            {
                                n = G.UIT.T,
                                config = {
                                    text = "IcyEthics, Balatro Modding Chat, and ",
                                    shadow = true,
                                    scale = scale * 0.8,
                                    colour = G.C.BLUE
                                }
                            },
                            {
                                n = G.UIT.T,
                                config = {
                                    text = "You!",
                                    shadow = true,
                                    scale = scale * 0.8,
                                    colour = G.C.DARK_EDITION
                                }
                            }
                        }
                    },
                }
            }
        end
    }
end