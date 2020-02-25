extends FSM_State

const MAX_SNAKE_COUNT = 3
var snake_counter = 0

func initialize():
	obj.anim_next = "summon"
	obj.show_jar()
	snake_counter = 0
	$SnakeTimer.start()
	obj.increment_cast_counter()

func terminate():
	obj.hide_jar()
	snake_counter = 0

func run(_delta):
	pass

const FLOAT_EPSILON = 1
static func floats_are_same(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon

func _on_SnakeTimer_timeout():
	if obj.is_dead:
		$SnakeTimer.stop()
		return
	obj.summon_snake()
	snake_counter += 1
	if snake_counter == MAX_SNAKE_COUNT:
		$SnakeTimer.stop()
		fsm.state_next = fsm.states.Idle
