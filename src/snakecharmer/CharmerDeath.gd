extends FSM_State

var start_warping = false
var is_done = false

func initialize():
	obj.anim_next = "cry"
	obj.set_wave_to_death()
	$Timer.start()
	obj.is_dead = true
	obj.stop_boss_music()

func terminate():
	pass

func run(_delta):
	if start_warping and !is_done:
		var lerp_scale_weight = 1
		var lerp_rotate_weight = 1
		
		obj.rotate.rotation = lerp(obj.rotate.rotation, 25, lerp_rotate_weight * _delta)
		obj.rotate.scale = lerp(obj.rotate.scale, Vector2.ZERO, lerp_scale_weight * _delta)
		
		if obj.rotate.scale.y <= .1:
			obj.release_door_and_free()
			is_done = true

const FLOAT_EPSILON = 1
static func floats_are_same(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon


func _on_Timer_timeout():
	start_warping = true
	obj.play_disappear_sound()
