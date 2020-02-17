extends Node

onready var types = get_node('/root/action_types')

func game_set_state(state):
	return {
		'type': action_types.GAME_SET_STATE,
		'state': state
	}

func game_set_level(level):
	return {
		'type': action_types.GAME_SET_LEVEL,
		'level': level
	}

func game_set_move_counter(move_counter):
	return {
		'type': action_types.GAME_SET_MOVE_COUNTER,
		'move_counter': move_counter
	}

func game_set_can_move(can_move):
	return {
		'type': action_types.GAME_SET_CAN_MOVE,
		'can_move': can_move
	}

func game_set_movement_vector(movement_vector):
	return {
		'type': action_types.GAME_SET_MOVEMENT_VECTOR,
		'movement_vector': movement_vector
	}
