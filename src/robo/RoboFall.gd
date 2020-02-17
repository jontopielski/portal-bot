extends FSM_State

func initialize():
	obj.anim_next = "fall"

func terminate():
	pass

func run(_delta):
	obj.vel.y = min(Constants.PLAYER_TERMINAL_VELOCITY, obj.vel.y + Constants.GRAVITY * _delta)
	obj.vel = obj.move_and_slide(obj.vel, Vector2.UP, true)
	if obj.is_on_floor():
		fsm.state_next = fsm.states.Idle
	else:
		if Input.is_action_pressed("ui_left"):
			obj.vel.x = lerp(obj.vel.x, -Constants.PLAYER_WALK_SPEED, Constants.PLAYER_FALL_ACCELERATION * _delta)
		elif Input.is_action_pressed("ui_right"):
			obj.vel.x = lerp(obj.vel.x, Constants.PLAYER_WALK_SPEED, Constants.PLAYER_FALL_ACCELERATION * _delta)
		else:
			obj.vel.x = lerp(obj.vel.x, 0, Constants.PLAYER_FALL_DECELERATION * _delta)
