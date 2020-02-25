extends FSM_State

func initialize():
	obj.anim_next = "idle"
	obj.set_wave_to_normal()
	obj.start_state_switch_timer()
	obj.chapter_two_ref.spawn_box_on_boss_fight_if_no_box_exists()

func terminate():
	pass

func run(_delta):
	pass

const FLOAT_EPSILON = 1
static func floats_are_same(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon
