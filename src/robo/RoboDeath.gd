extends FSM_State

func initialize():
	pass

func terminate():
	obj.rotate.rotation = 0
	obj.rotate.scale = Vector2.ONE

func run(_delta):
	obj.vel.y = min(Constants.PLAYER_TERMINAL_VELOCITY, obj.vel.y + Constants.GRAVITY * _delta)
	obj.vel.x = 0
	obj.vel = obj.move_and_slide(obj.vel, Vector2.UP, true)
	
	var lerp_scale_weight = 5
	obj.rotate.scale = lerp(obj.rotate.scale, Vector2.ZERO, lerp_scale_weight * _delta)

	if obj.rotate.scale.y <= .1:
		obj.position = obj.save_point_pos
		fsm.state_next = fsm.states.Idle
