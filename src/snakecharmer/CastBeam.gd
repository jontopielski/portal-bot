extends Node2D

var cast_color = Color.white
var position_offset = Vector2(0, 0)
var is_moving_down = true
var radius_counter = 0
var width = 2
var max_radius = 20

func _ready():
	pass

func _draw():
	draw_circular_arc(position_offset, radius_counter, 0, 360, cast_color, 1.0, 16)

func draw_circular_arc(center, rad, angle_from, angle_to, color, curviness, nb_points):
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var next_point = Vector2(cos(angle_point) * 1 / curviness, \
			sin(angle_point) * curviness) * rad
		points_arc.push_back(center + next_point)
#		draw_circle(center + next_point, 5, Color.white)
	draw_polyline(points_arc, color, width)

func set_color(color):
	cast_color = color

func _on_MoveTimer_timeout():
	match position_offset:
		Vector2(0, 0):
			position_offset = Vector2(0, 1)
			is_moving_down = true
		Vector2(0, 1):
			if is_moving_down:
				position_offset = Vector2(0, 2)
			else:
				position_offset = Vector2(0, 0)
		Vector2(0, 2):
			position_offset = Vector2(0, 1)
			is_moving_down = false
	update()


func _on_RadiusTimer_timeout():
	radius_counter += 1
	update()
	if radius_counter >= max_radius:
		queue_free() 
