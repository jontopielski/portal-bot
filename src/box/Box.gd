extends KinematicBody2D

var vel = Vector2()

onready var rotate = $Rotate
onready var fsm = FSM.new(self, $States, $States/Idle, true)
onready var collision_shape = $CollisionShape2D

var last_portal_coordinates = Vector2.ZERO
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

func _on_Area2D_body_entered(body):
	print("BOX COLLIDED WITH ", body.name)
	if "SnakeCharmer" in body.name:
		body.take_damage()
		queue_free()
