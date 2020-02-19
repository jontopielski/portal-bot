extends Node2D

var radius = 3.0
var curviness = 1.0

func _ready():
	randomize()
	curviness = float(randi() % 4 + 8) / 10.0

func _draw():
	draw_circular_arc(Vector2.ZERO, radius, 0, 360, Color.white, curviness,  5)
#	draw_circle(Vector2.ZERO, radius, Color.white)
#	draw_circle(Vector2.ZERO, radius/2.0, Color.black)

func draw_circular_arc(center, radius, angle_from, angle_to, color, curviness, nb_points):
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var next_point = Vector2(cos(angle_point) * 1 / curviness, \
			sin(angle_point) * curviness) * radius
		points_arc.push_back(center + next_point)
	draw_colored_polygon(points_arc, color)


func set_position(pos):
	position = pos

func _on_Timer_timeout():
	radius -= 1
	position.y -= 2.5
	if radius <= 0:
		queue_free()
	update()
