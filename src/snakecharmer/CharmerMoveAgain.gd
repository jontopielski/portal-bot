extends FSM_State

var target_position = Vector2.ZERO

func initialize():
	obj.anim_next = "still"
	obj.update_corner_positions()
	target_position = obj.get_current_corner_position()
	if Constants.DEBUG_MODE:
		print("Attempting to go towards position ", target_position)

func terminate():
	pass

func run(_delta):
	obj.position.y = lerp(obj.position.y, target_position.y, Constants.SNAKECHARMER_SPEED * _delta)
	obj.position.x = lerp(obj.position.x, target_position.x, Constants.SNAKECHARMER_SPEED * _delta)
	if floats_are_same(obj.position.x, target_position.x) and floats_are_same(obj.position.y, target_position.y):
		if obj.is_in_corner():
			fsm.state_next = fsm.states.Idle
		else:
			fsm.state_next = fsm.states.Move

const FLOAT_EPSILON = 1.0
static func floats_are_same(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon
