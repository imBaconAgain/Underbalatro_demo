-- Items

SMODS.ConsumableType{
	key = "items",
	primary_colour = G.C.BLACK,
	secondary_colour = G.C.BLACK,
	loc_txt = {
		name = "ITEM",
		collection = "ITEM",
	},
	shop_rate = 1
}

-- Bullet

SMODS.Atlas{
	key = 'bullet',
	path = 'bullet.png',
	px = 71,
	py = 95
}

SMODS.Consumable{
	key = "bullet",
	set = "items",
	loc_txt = {
		name = 'Bullet',
		text = {
			'Destroy {C:attention}1{} selected',
			'card'
		}
	},
	atlas = 'bullet',
	cost = 2,
	pos = {x = 0, y = 0},
	can_use = function(self,card)
		return #G.hand.highlighted == 1
	end,
	in_pool = function(self,args)
		return true
	end,
	loc_vars = function(self,info_queue,center)

	end,
	use = function(self,card,area,copier)
		G.E_MANAGER:add_event(Event({
			G.hand.highlighted[1]:start_dissolve()
		}))
	end
}

-- Snowman Piece

SMODS.Atlas{
	key = 'spiece',
	path = 'spiece.png',
	px = 71,
	py = 95
}

SMODS.Consumable{
	key = "spiece",
	set = "items",
	loc_txt = {
		name = 'Snowman Piece',
		text = {
			'Gains {C:money}$1{} of',
			'{C:attention}sell value{} at',
			'end of round'
		}
	},
	atlas = 'spiece',
	cost = 2,
	pos = {x = 0, y = 0},
	config = {extra = {price = 1}},
	can_use = function(self,card)
		return false
	end,
	in_pool = function(self,args)
		return true
	end,
	loc_vars = function(self,info_queue,center)

	end,
	calculate = function(self,card,context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra_value = card.ability.extra_value + card.ability.extra.price
			card:set_cost()
			return {
				message = localize('k_val_up'),
				colour = G.C.MONEY
			}
		end
	end,
}

-- Last Dream

SMODS.Atlas{
	key = 'lastdream',
	path = 'lastdream.png',
	px = 71,
	py = 95
}

SMODS.Consumable{
	key = "lastdream",
	set = "items",
	loc_txt = {
		name = '{C:ub_rainbow}Last Dream{}',
		text = {
			'{C:ub_rainbow}The dream became true{}'
		}
	},
	atlas = 'lastdream',
	cost = 4,
	pos = {x = 0, y = 0},
	config = {extra = {price = 1}},
	can_use = function(self,card)
		return #G.hand.highlighted == 1
	end,
	in_pool = function(self,args)
		return true
	end,
	loc_vars = function(self,info_queue,center)

	end,
	use = function(self,card,area,copier)
		G.E_MANAGER:add_event(Event({
			G.hand.highlighted[1]:set_ability(G.P_CENTERS["m_ub_dreams"])
		}))	
	end,
}

-- Capsule
--[[
SMODS.Atlas{
	key = 'capsule',
	path = 'capsule.png',
	px = 71,
	py = 95
}
--]]
SMODS.Consumable{
	key = "capsule",
	set = "items",
	loc_txt = {
		name = 'Capsule',
		text = {
			'Store a {C:attention}Joker{}.',
			'Sell, to recover him',
			'{C:inactive}(Must have room){}'
		}
	},
	atlas = 'ph',
	cost = 7,
	pos = {x = 0, y = 0},
	config = {extra = {
		joker_saved = ''
	}
	},
	can_use = function(self,card)
		return #G.jokers.highlighted == 1
	end,
	in_pool = function(self,args)
		return true
	end,
	loc_vars = function(self,info_queue,card)
		info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.joker_saved]
	end,
	calculate = function(self, card, context)
		if context.selling_self then
			if card.ability.extra.joker_saved ~= '' then
    			SMODS.add_card({key = card.ability.extra.joker_saved})
			end
		end
	end,
	keep_on_use = function(self,card)
		return true
	end,
	use = function(self,card,area,copier)
		if card.ability.extra.joker_saved == '' then
			card.ability.extra.joker_saved = G.jokers.highlighted[1].config.center.key
			G.E_MANAGER:add_event(Event({
				G.jokers.highlighted[1]:start_dissolve(),
			}))	
		end
	end,
}

-- Failed Experiment

SMODS.Consumable{
	key = "failed",
	set = "items",
	loc_txt = {
		name = 'Failed Experiment',
		text = {
			'{C:green}1 in 7{} chance to give',
			'{C:dark_edition}negative{} to a {C:attention}Joker',
		}
	},
	atlas = 'ph',
	cost = 7,
	pos = {x = 0, y = 0},
	config = {extra = {
		joker_saved = ''
	}
	},
	can_use = function(self,card)
		return next(SMODS.Edition:get_edition_cards(G.jokers,true))
	end,
	in_pool = function(self,args)
		return false
	end,
	loc_vars = function(self,info_queue,card)
		info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.joker_saved]
	end,
	calculate = function(self, card, context)
		if context.selling_self then
			if card.ability.extra.joker_saved ~= '' then
    			SMODS.add_card({key = card.ability.extra.joker_saved})
			end
		end
	end,
	use = function(self,card,area,copier)
		local chance = math.random(1,7)
		if chance == 1 then
			local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers,true)
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					local eligible_card = pseudorandom_element(editionless_jokers,pseudoseed('failed'))
					eligible_card:set_edition({ negative = true })

					card:juice_up(0.3,0.5)
					return true
				end
			}))
		end
	end,
}

-- Butterscotch Pie

SMODS.Consumable{
	key = "pie",
	set = "items",
	loc_txt = {
		name = 'Butterscotch Pie',
		text = {
			'Instantly obtain {C:attention}90%{}',
            'of the Blind requirement.'
		}
	},
	atlas = 'ph',
	cost = 15,
	pos = {x = 0, y = 0},
	config = {extra = {
		
	}
	},
	can_use = function(self,card)
		return G.GAME.blind.in_blind
	end,
	in_pool = function(self,args)
		return false
	end,
	loc_vars = function(self,info_queue,card)

	end,
	calculate = function(self, card, context)
		
	end,
	use = function(self,card,area,copier)
		local perc = G.GAME.blind.chips * 0.9
        G.GAME.chips = G.GAME.chips + perc
	end,
}