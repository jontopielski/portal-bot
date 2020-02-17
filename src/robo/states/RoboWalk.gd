extends FSM_State

func initialize():
	pass

func terminate():
	pass

func run(_delta):
	obj.vel.y = min(Constants.PLAYER_TERMINAL_VELOCITY, obj.vel.y + Constants.GRAVITY * 10.0 * _delta)
	obj.vel = obj.move_and_slide(obj.vel, Vector2.UP, true)
	if obj.is_on_floor():
		if Input.is_action_pressed("ui_left"):
			if obj.rotate.scale.x == -1:
				obj.anim_next = "walk"
			else:
				obj.anim_next = "walk_back"
			obj.vel.x = lerp(obj.vel.x, -Constants.PLAYER_WALK_SPEED, Constants.PLAYER_WALK_ACCELERATION * _delta)
		elif Input.is_action_pressed("ui_right"):
			if obj.rotate.scale.x == 1:
				obj.anim_next = "walk"
			else:
				obj.anim_next = "walk_back"
			obj.vel.x = lerp(obj.vel.x, Constants.PLAYER_WALK_SPEED, Constants.PLAYER_WALK_ACCELERATION * _delta)
		else:
			fsm.state_next = fsm.states.Idle
	else:
		fsm.state_next = fsm.states.Fall
