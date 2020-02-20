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
