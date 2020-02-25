extends FSM_State

const MAX_CAST_COUNT = 3
var cast_counter = 0

func initialize():
	obj.anim_next = "cast"
	obj.set_wave_to_wide()
	cast_counter = 0
	obj.update_next_cast_type()
#	$CastWarningTimer.start()
	obj.start_cast_warning()
	$CastTimer.start()

func terminate():
	obj.set_wave_to_normal()
	cast_counter = 0
	obj.increment_cast_counter()

func run(_delta):
	pass

const FLOAT_EPSILON = 1
static func floats_are_same(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon

func _on_CastTimer_timeout():
	if obj.is_dead:
		$CastTimer.stop()
		$CastWarningTimer.stop()
		return
	obj.cast_attack()
	cast_counter += 1
	if cast_counter == MAX_CAST_COUNT:
		$CastTimer.stop()
		fsm.state_next = fsm.states.Idle
	else:
		obj.update_next_cast_type()
		obj.start_cast_warning()
		$CastTimer.start()

#func _on_CastWarningTimer_timeout():
#	$CastTimer.start()
#	obj.start_cast_warning()
