extends FSM_State

func initialize():
	obj.vel.y = 0
	obj.vel.x = 0

func terminate():
	obj.rotate.rotation = 0
	obj.rotate.scale = Vector2.ONE

func run(_delta):
	var lerp_scale_weight = 10
	var lerp_rotate_weight = 5
	
	obj.rotate.rotation = lerp(obj.rotate.rotation, 0, lerp_rotate_weight * _delta)
	obj.rotate.scale = lerp(obj.rotate.scale, Vector2.ONE, lerp_scale_weight * _delta)

	if obj.rotate.scale.y > 0.90 and obj.rotate.rotation < 1:
		fsm.state_next = fsm.states.Idle
