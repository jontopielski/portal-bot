extends FSM_State

func initialize():
	obj.anim_next = "walk"

func terminate():
	pass

func run(_delta):
	obj.vel.y = min(Constants.PLAYER_TERMINAL_VELOCITY, obj.vel.y + Constants.GRAVITY * 10.0 * _delta)
	obj.vel = obj.move_and_slide(obj.vel, Vector2.UP, true)
	if Globals.CurrentRoom != obj.room:
		fsm.state_next = fsm.states.Idle
	if obj.is_on_floor():
		if Globals.PlayerPosition.x < obj.position.x:
			obj.vel.x = lerp(obj.vel.x, -Constants.PLAYER_WALK_SPEED, Constants.PLAYER_WALK_ACCELERATION * _delta)
		elif Globals.PlayerPosition.x > obj.position.x:
			obj.vel.x = lerp(obj.vel.x, Constants.PLAYER_WALK_SPEED, Constants.PLAYER_WALK_ACCELERATION * _delta)
		else:
			fsm.state_next = fsm.states.Idle
	else:
		fsm.state_next = fsm.states.Fall
