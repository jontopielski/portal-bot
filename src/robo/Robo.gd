extends KinematicBody2D

var vel = Vector2()

var dir_next = 1

var anim_curr = ""
var anim_next = ""

var save_point_pos = Vector2(44, 52)

onready var rotate = $Rotate
onready var fsm = FSM.new(self, $States, $States/Idle, true)

func _ready():
	pass

func _physics_process(delta):
	fsm.run_machine(delta)
	set_direction()
	
	if anim_curr != anim_next:
		anim_curr = anim_next
		$AnimationPlayer.play(anim_curr)

	if dir_next != rotate.scale.x:
		rotate.scale.x = dir_next
	
func set_direction():
	var mouse_offset = get_global_mouse_position() - global_position
	
	if mouse_offset.x > 0:
		dir_next = 1
	elif mouse_offset.x < 0:
		dir_next = -1

func set_next_state(state):
	fsm.state_next = state
