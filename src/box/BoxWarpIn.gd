extends FSM_State

func initialize():
	obj.vel.y = 0
	obj.vel.x = 0
#	obj.collision_shape.disabled = true

func terminate():
	pass

func run(_delta):
	var lerp_scale_weight = 5
	var lerp_rotate_weight = 1
	
	obj.rotate.rotation = lerp(obj.rotate.rotation, 25, lerp_rotate_weight * _delta)
	obj.rotate.scale = lerp(obj.rotate.scale, Vector2.ZERO, lerp_scale_weight * _delta)
	
	if obj.rotate.scale.y <= .1:
		if Globals.PortalQueue.size() > 0:
			obj.position = Globals.get_next_portal_position(obj.last_portal_coordinates, true)
			fsm.state_next = fsm.states.WarpOut
