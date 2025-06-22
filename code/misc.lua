-----------------------CHALLENGES!--------------------------
SMODS.Challenge{
    key = 'snowgrave_1',
    loc_txt = {
        name = 'Snowgrave'
    },
    rules = {
        modifiers = {
            { id = 'joker_slots', value = 2}
        }
    },
    jokers = {
        { id = 'j_ub_noelle', eternal = true},
        { id = 'j_ub_snowdin', eternal = true}
    },
    restrictions = {
        banned_cards = {
            { id = 'c_judgement' },
            { id = 'c_wraith' },
            { id = 'c_soul' },
            { id = 'p_standard_normal_1', ids = {
                'p_standard_normal_1', 'p_standard_normal_2',
                'p_standard_normal_3', 'p_standard_normal_4',
                'p_standard_jumbo_1', 'p_standard_jumbo_2',
                'p_standard_mega_1', 'p_standard_mega_2' }
            },
        },
        banned_tags = {
            { id = 'tag_uncommon' },
            { id = 'tag_rare' },
            { id = 'tag_negative' },
            { id = 'tag_foil' },
            { id = 'tag_holographic' },
            { id = 'tag_polychrome' },
            { id = 'tag_buffoon' },
            { id = 'tag_top_up' },
        },
        banned_other = {
            { id = 'bl_final_heart', type = 'blind' },
            { id = 'bl_final_leaf',  type = 'blind' },
            { id = 'bl_final_acorn', type = 'blind' },
        }
    }
}

--------------------TAGS-------------------------
SMODS.Tag{
    key = 'dcandy',
    loc_txt = {
        name = 'Dark Candy Tag',
        text = {
            'Gives {C:attention}5%{} of the',
            '{C:attention}blind{} requirement'
        }
    },
    apply = function (self,tag,context)
        if context.setting_blind then
            local perc = G.GAME.blind.chips * 0.05
            G.GAME.chips = perc
            tag:yep()
            tag.triggered = true
        end
    end
}
