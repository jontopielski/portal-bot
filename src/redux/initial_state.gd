extends Node

static func get_state():
	return {
		'game': get_substate('game')
	}

static func get_state_property(substate, key):
	return get_state()[substate][key]

static func get_substate(substate):
	match substate:
		'game':
			return {
				'state': Globals.GameState.INTRO,
				'level': 1,
				'can_move': true,
				'movement_vector': Vector2(),
				'move_counter': 0
			}
	return {}

static func get_initial_state_property(substate, key):
	return get_substate(substate)[key]
