extends Node2D

const font = preload("res://assets/fonts/3x6Font.tres")

var text = "i was never programmed to jump"
var draw_position = Vector2(25, -20)

func _ready():
	pass

func _process(delta):
	draw_position.y = lerp(draw_position.y, 10, .05)
	update()

func _draw():
	draw_string(font, draw_position, text, Color.white)

func set_text(t):
	text = t
