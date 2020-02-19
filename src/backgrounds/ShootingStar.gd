extends Node2D

var color = Color(1, 1, 1, .5)
var width = 0
var height = 0
var can_start_moving = false
var starting_position = Vector2.ZERO
var move_amount_x = 5

func _ready():
	randomize()
	width = randi() % 2 + 1
	height = 1
	color.a = (randi() % 25 + 40) / 100.0
	randomize()
	starting_position.x = get_viewport().size.x + (get_viewport().size.x / 10.0)
	randomize()
	starting_position.y = randi() % 50 + 5
	randomize()
	move_amount_x = randi() % 2 + 3
	position = starting_position
	$DelayStartTimer.wait_time = float(randi() % 2 + 1) / 10.0
	$DelayStartTimer.start()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, Vector2(width, height)), color, true)

func _on_MoveTimer_timeout():
	if can_start_moving:
		position.x -= move_amount_x
		if position.x < 0:
			queue_free()

func _on_DelayStartTimer_timeout():
	can_start_moving = true
