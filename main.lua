------------------------------------------------
------------MOD CODE ---------------------------

------------------------------OTHERS--------------------------------------

UNDERBALATRO = SMODS.current_mod

local allFolders = {
    "code",
}
local allFiles = {
	["code"] = {"darkjokers", 'jokers','bigfunctions','seals','enhancements','consumeables','misc'},
}

for i = 1,#allFolders do
    if allFolders[i] == "none" then
        for i2 = 1,#allFiles[allFolders[i]] do
            assert(SMODS.load_file(allFiles[allFolders[i]][i2]..'.lua'))()
        end
    else
        for i2 = 1,#allFiles[allFolders[i]] do
            assert(SMODS.load_file(allFolders[i].."/"..allFiles[allFolders[i]][i2]..'.lua'))()
        end
    end
end

SMODS.current_mod.optional_features = function()
    return {
        quantum_enhancements = true
    }
end

-- item placeholder
SMODS.Atlas{
	key = 'ph',
	path = 'ph.png',
	px = 71,
	py = 95
}

SMODS.Atlas{
	key = 'ph2',
	path = 'ph2.png',
	px = 71,
	py = 95
}

G.localization.descriptions.Other['ph'] = {
    name = 'Placeholder',
    text = {
        "This card's art",
		"is a placeholder"
    }
}

G.localization.descriptions.Other['unfinished'] = {
    name = 'Unfinished',
    text = {
        "This card is",
		'unfinished!'
    }
}

G.localization.descriptions.Other['unsupported'] = {
    name = 'Unsupported!',
    text = {
        "This joker's mod",
		'isn\'t supported!'
    }
}

SMODS.Gradient{
	key = 'rainbow',
	colours = {
		G.C.RED,
		HEX('FF5100'),
		HEX('FFC800'),
		HEX('C3FF00'),
		HEX('37FF00'),
		HEX('00FF6A'),
		HEX('00FFEA'),
		HEX('0099FF'),
		HEX('001EFF'),
		HEX('6200FF'),
		HEX('FF00E1')
	},
	cycle = 4,
	interpolation = 'linear'
}

function UNDERBALATRO.create_fake_joker(ref, key, reason, juicecard)
	local center = G.P_CENTERS[key]
	local ability
	local cardformsg = juicecard or ref
	if reason then
		if reason == 'calculate' or reason == 'use' then
			ability = ref.ability.savedvalues[key]
		elseif reason == 'add_to_deck' or reason == 'remove_from_deck' then
			ability = center.config
		end
	end
	if ability then
		ability.set = center.set
		ability.name = center.name
	end
	local fake_card = {
		ability = ability or ref.ability,
		config = {
			center = center,
		},
		sealsfakecard = true,
		sealsmessagecard = cardformsg,
		T = copy_table(ref.T),
		VT = copy_table(ref.V),
		children = ref.children,
		states = copy_table(ref.states),
		role = {
			role_type = 'Major',
			offset = {x=0,y=0},
			major = nil,
			draw_major = ref,
			xy_bond = 'Strong',
			wh_bond = 'Strong',
			r_bond = 'Strong',
			scale_bond = 'Strong'
		},
		alignment = {
			type = 'a',
			offset = {x=0,y=0},
			prev_type = '',
			prev_offset = {x=0,y=0}
		},
		base_cost = ref.base_cost,
        area = ref.area,
        CT = ref.CT,
        ambient_tilt = 0.2,
        tilt_var = {mx = 0, my = 0, dx = 0, dy = 0, amt = 0},
        params = ref.params,
        sell_cost = ref.sell_cost,
        cost = ref.cost,
        unique_val = ref.unique_val,
        zoom = true,
        discard_pos = {
            r = 0,
            x = 0,
            y = 0,
        },
        facing = 'front',
        sprite_facing = 'front',
        click_timeout = 0.3,
        original_T = copy_table(ref.T),
    }
    fake_card.ability.extra_value = ref.ability.extra_value or 0
    fake_card.ability.cry_prob = ref.ability.cry_prob or 1
    for k, v in pairs(Card) do
        if type(v) == "function" then
            fake_card[k] = v
        end
    end
    fake_card.juice_up = function(self, scale, rot_amount)
        return cardformsg:juice_up(scale, rot_amount)
    end
    fake_card.remove = function(self)
        return nil
    end
    return fake_card
end

function UNDERBALATRO.get_joker_return(key, context, card, isvanilla, juicecard)
    local center = G.P_CENTERS[key]
    if center then
        card.ability.savedvalues = card.ability.savedvalues or {}
        card.ability.savedvalues[key] = card.ability.savedvalues[key] or copy_table(center.config)
        local fake_card = UNDERBALATRO.create_fake_joker(card, key, "calculate", juicecard)
        if card.config.center.key == "j_soe_allinone" then
            card.ability.extra.currentjoker = center
        end
        if center.calculate and type(center.calculate) == "function" and not isvanilla then
            return center:calculate(fake_card, context), fake_card
        end
        if isvanilla then
            return UNDERBALATRO.get_vanilla_joker_return(key, context, fake_card), fake_card
        end
    end
end

function table.contains(table, element)
    if table and type(table) == "table" then
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end
end

UNDERBALATRO.jokers = {}
for k,v in pairs(G.P_CENTERS) do
	if v.set == "Joker" then
		table.insert(UNDERBALATRO.jokers,v)
	end
end

UNDERBALATRO.consumeables = {}
for k,v in pairs(G.P_CENTERS) do
	if v.set == "Consumable" then
		table.insert(UNDERBALATRO.consumeables,v)
	end
end

--[[local underbalatrojokers = {
	'det',
	'bravery',
	'justice',
	'kindness',
	'patience',
	'integrity',
	'perseverance',
	'monster',
	'soulwheel',
	'flowey',
	'amalgam',
	'g',
	'gaster',
	'ferryman',
	'deltarune',
	'asgore',
	'susie',
	'ralsei',
	'kris',
	'dfountain',
	'ruins',
	'snowdin',
	'waterfall',
	'hotland',
	'core'
}]]
UNDERBALATRO.tarots = {
	'fool',
	'magician',
	'high_priestess',
	'empress',
	'emperor',
	'hierophant',
	'lovers',
	'chariot',
	'justice',
	'hermit',
	'wheel_of_fortune',
	'strength',
	'hanged_man',
	'death',
	'temperance',
	'devil',
	'tower',
	'star',
	'moon',
	'sun',
	'judgement',
	'world'
}

--Hooking!
local oldcardremove = Card.remove
function Card:remove()
	if self.added_to_deck and self.ability.set == 'Joker' and not G.CONTROLLER.locks.selling_card then
		SMODS.calculate_context({ub_destroyedcard = self.config.center_key})
	end
	return oldcardremove(self)
end

local oldcardremove2 = Card.remove
function Card:remove()
	if self.added_to_deck and self.ability.set == 'Card' and not G.CONTROLLER.locks.selling_card then
		SMODS.calculate_context({ub_destroyedcardns = true})
	end
	return oldcardremove2(self)
end

local oldcansellcard = Card.can_sell_card
function Card:can_sell_card(context)
	local g = oldcansellcard(self,context)
	if (G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0) then return false end
	if self.config.center.key == 'j_ub_dfountain' then return false end
	return g
end

local use_and_sell_buttonsref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	local retval = use_and_sell_buttonsref(card)
	if card.area and card.area.config.type == 'joker' and card.ability.set == 'Joker' and card.ability.deal then
		local fuse = 
		{n=G.UIT.C, config={align = "cr"}, nodes={
		  
		  {n=G.UIT.C, config={ref_table = card, align = "cr",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.GOLD, one_press = true, button = 'sell_card', func = 'can_fuse_card'}, nodes={
			{n=G.UIT.B, config = {w=0.1,h=0.6}},
			{n=G.UIT.C, config={align = "tm"}, nodes={
				{n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
					{n=G.UIT.T, config={text = 'DEAL',colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
				}},
				{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
					{n=G.UIT.T, config={ref_table = card, ref_value = 'fusion_cost',colour = G.C.WHITE, scale = 0.55, shadow = true}}
				}}
			}}
		  }}
		}}
		retval.nodes[1].nodes[2].nodes = retval.nodes[1].nodes[2].nodes or {}
		table.insert(retval.nodes[1].nodes[2].nodes, fuse)
		return retval
	end

	return retval
end

local oldsetcost = Card.set_cost
function Card:set_cost()
	local g = oldsetcost(self)
	if self.config.center.key == 'j_ub_spamton' then self.sell_cost = self.sell_cost - 1 end
	return g
end

-- Mystery Raririty

SMODS.Rarity{
	key = "mystery",
	loc_txt = {
		name = 'Place'
	},
	badge_colour = HEX('a5d9ab'),
	default_weight = 0.6
}

--not implemented

------------------------------EDITIONS--------------------------------------

-- template
--[[
SMODS.Edition{
	key = "corrupt",
	shader = true,
	loc_txt = {
		name = "Corrupted",
		text = {
			"{C:red}-3{} Mult"
		}
	},
	config = {extra = {
		mult = -3
	}
	},
	in_shop = false,
	apply_to_float = true,
}
--]]

------------------------------BLINDS--------------------------------------
--[[
SMODS.Blind{
	key = 'tori',
	loc_txt = {
		name = "Toriel",
		description = {
			'Discards cards',
			'to the rightmost',
			'and to the leftmost'
		}
	},
	dollars = 5,
	mult = 2,
	boss = {min = 1},
	boss_colour = HEX("ff2414"),
	set_blind = function(self)
		G.GAME.blind.prepped = nil
	end,
	calculate = function(self,blind,context)
		if not blind.disabled then
			if context.press_play then
				G.hand:add_to_highlighted(G.hand.cards[1])
				G.hand:add_to_highlighted(G.hand.cards[#G.hand])
				G.FUNS.discard_cards_from_highlighted(nil,true)
			end
		end
	end,
}
]]
------------------------------------------------
------------MOD CODE END------------------------