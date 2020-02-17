extends FSM_State

func initialize():
	obj.anim_next = "idle"

func terminate():
	pass

func run(_delta):
	obj.vel.y = min(Constants.PLAYER_TERMINAL_VELOCITY, obj.vel.y + Constants.GRAVITY * 10.0 * _delta)
	obj.vel.x = lerp(obj.vel.x, 0, Constants.PLAYER_WALK_DECELERATION * _delta)
	obj.vel = obj.move_and_slide(obj.vel, Vector2.UP, true)
	if obj.is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			fsm.state_next = fsm.states.Walk
	else:
		fsm.state_next = fsm.states.Fall
