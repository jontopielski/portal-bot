extends FSM_State

func initialize():
	obj.vel.y = 0
	obj.vel.x = 0

func terminate():
	pass

func run(_delta):
	var lerp_scale_weight = 5
	var lerp_rotate_weight = 1
	
	obj.rotate.rotation = lerp(obj.rotate.rotation, 25, lerp_rotate_weight * _delta)
	obj.rotate.scale = lerp(obj.rotate.scale, Vector2.ZERO, lerp_scale_weight * _delta)

	if obj.rotate.scale.y <= .1:
		obj.position = Vector2(305, 15)
		fsm.state_next = fsm.states.WarpOut
