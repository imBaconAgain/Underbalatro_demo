-- Dreamy

SMODS.Atlas{
	key = 'dreamy',
	path = 'dreamy.png',
	px = 71,
	py = 95
}

SMODS.Enhancement{
	key = "dreams",
	loc_txt = {
		name = "Dreams",
		text = {
			"{X:ub_rainbow,C:black}X1.5{} of whatever",
			'you dream of'
		},
	},
	config = {extra = {
		Xmult = 0,
		Xchips = 0
	}
	},
	atlas = "dreamy",
	calculate = function(self,card,context)
		if context.main_scoring then
			return { 
				Xmult_mod = 1.5, 
				Xchips_mod = 1.5,
				message = "X1.5 Chips and Mult",
				colour = G.C.PURPLE
			}
		end
	end
}

-- Snowy

SMODS.Atlas{
	key = 'snowy',
	path = 'snowy.png',
	px = 88,
	py = 123
}


SMODS.Enhancement{
	key = "snowy",
	loc_txt = {
		name = "Snowy",
		text = {
			'{X:chips,C:white}X1.2{} chips for',
			'every other scoring',
			'{C:attention}Snowy{} card'
		}
	},
	config = {extra = {

	}
	},
	display_size = { w = 88.0, h = 123 },
	atlas = "snowy",
	calculate = function(self,card,context)
		if context.main_scoring and context.cardarea == G.play then
			local snowy_xchips = 1
			for _,i in ipairs(context.scoring_hand) do
				if SMODS.has_enhancement(i, 'm_ub_snowy') and i ~= card then
					snowy_xchips = snowy_xchips +0.2
				end
			end
			return {xchips = snowy_xchips}
		end
	end
}