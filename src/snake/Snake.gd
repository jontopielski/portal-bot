extends KinematicBody2D

var vel = Vector2()

var dir_next = 1

var anim_curr = ""
var anim_next = ""
var room = Vector2.ZERO

onready var rotate = $Rotate
onready var fsm = FSM.new(self, $States, $States/Idle, true)

func _physics_process(delta):
	fsm.run_machine(delta)
	set_direction()
	
	if anim_curr != anim_next:
		anim_curr = anim_next
		$AnimationPlayer.play(anim_curr)

	if dir_next != rotate.scale.x:
		rotate.scale.x = dir_next
	
	if position.x < room.x * 160 or (position.x > ((room.x * 160) + 160)):
		print("SNAKE OFF SCREEN")
		queue_free()
	elif position.y < room.y * 90 or (position.y > ((room.y * 90) + 90)):
		print("SNAKE OFF SCREEN")
		queue_free()

func set_room(r):
	room = r

func set_spawn_position(pos):
	position = pos

func set_direction():
	var player_offset = Globals.PlayerPosition - global_position
	
	if player_offset.x > 0:
		dir_next = -1
	elif player_offset.x < 0:
		dir_next = 1

func _on_Area2D_body_entered(body):
	if body.name == "Robo":
		if body.fsm.state_curr != body.fsm.states.WarpOut and body.fsm.state_curr != body.fsm.states.WarpIn:
			body.cause_of_death = Globals.DeathCause.SPIKES
			body.fsm.state_next = body.fsm.states.Death
