extends FSM_State

func initialize():
	obj.fade_in()
	pass

func terminate():
	obj.fade_out()
	obj.rotate.rotation = 0
	obj.rotate.scale = Vector2.ONE
	obj.arm.scale = Vector2.ONE
	
#	Globals.clear_portals()
	obj.get_parent().clear_all_shit()

func run(_delta):
	if obj.cause_of_death == Globals.DeathCause.SPIKES:
		obj.vel.y = min(Constants.PLAYER_TERMINAL_VELOCITY, obj.vel.y + Constants.GRAVITY * _delta)
	else:
		obj.vel.y = 0
	obj.vel.x = 0
	obj.vel = obj.move_and_slide(obj.vel, Vector2.UP, true)
	
	var lerp_scale_weight = 5
	obj.rotate.scale = lerp(obj.rotate.scale, Vector2.ZERO, lerp_scale_weight * _delta)
	obj.arm.scale = lerp(obj.arm.scale, Vector2.ZERO, lerp_scale_weight * _delta)

	if obj.rotate.scale.y <= .1:
		obj.position = obj.save_point_pos
		fsm.state_next = fsm.states.Idle
