extends Node

static func get_state():
	return {
		'game': get_substate('game'),
		'portal': get_substate('queue')
	}

static func get_state_property(substate, key):
	return get_state()[substate][key]

static func get_substate(substate):
	match substate:
		'game':
			return {
				'state': Globals.GameState.INTRO,
				'level': 1
			}
		'portal':
			return {
				'queue': []
			}
	return {}

static func get_initial_state_property(substate, key):
	return get_substate(substate)[key]
