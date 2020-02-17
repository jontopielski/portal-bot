extends Node

#onready var initial_state = get_node('res://src/redux/initial_state.gd')

onready var types = get_node('/root/action_types')
onready var store = get_node('/root/store')

func game(state, action):
	if state.empty() and action['type'] == null:
		return initial_state.get_substate('game')
	if action['type'] == action_types.GAME_SET_STATE:
		var next_state = store.shallow_copy(state)
		next_state['state'] = action['state']
		return next_state
	if action['type'] == action_types.GAME_SET_LEVEL:
		var next_state = store.shallow_copy(state)
		next_state['level'] = action['level']
		return next_state
	if action['type'] == action_types.GAME_SET_CAN_MOVE:
		var next_state = store.shallow_copy(state)
		next_state['can_move'] = action['can_move']
		return next_state
	if action['type'] == action_types.GAME_SET_MOVEMENT_VECTOR:
		var next_state = store.shallow_copy(state)
		next_state['movement_vector'] = action['movement_vector']
		return next_state
	if action['type'] == action_types.GAME_SET_MOVE_COUNTER:
		var next_state = store.shallow_copy(state)
		next_state['move_counter'] = action['move_counter']
		return next_state
	return state

func portal(state, action):
	if state.empty() and action['type'] == null:
		return initial_state.get_substate('portal')
	if action['type'] == action_types.GAME_SET_STATE:
		var next_state = store.shallow_copy(state)
		next_state['state'] = action['state']
		return next_state
	if action['type'] == action_types.PORTAL_CLEAR_QUEUE:
		var next_state = store.shallow_copy(state)
		next_state['queue'].clear()
		return next_state
	if action['type'] == action_types.PORTAL_PUSH_BACK_QUEUE:
		var next_state = store.shallow_copy(state)
		next_state['queue'].push_back(action['portal'])
		return next_state
	return state
