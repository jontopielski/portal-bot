extends KinematicBody2D

var vel = Vector2()

onready var rotate = $Rotate
onready var fsm = FSM.new(self, $States, $States/Idle, true)

var spawn_position = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	fsm.run_machine(delta)
	check_out_of_bounds()

func check_out_of_bounds():
	if position.y > spawn_position.y + 200:
		print("DELETING BOX BECAUSE IT IS OUT OF BOUNDS")
		queue_free()

func set_spawn_position(pos):
	spawn_position = pos
	position = pos
