extends Node2D

const hole_color = Color.black
const spiral_color = Color.red

var TEMP_START_POS = Vector2(0, 0)
var radius = 5
var curviness = 1
var max_curviness = 1
var min_curviness = 1
var curviness_direction = 1
var spiral_rotation = 0
var spiral_points = []

func _ready():
	curviness = (max_curviness + min_curviness) / 2.0
	for i in range(0, 6):
		spiral_points.push_back(get_spiral_points(i));

func _draw():
	draw_polygon(spiral_points[spiral_rotation], PoolColorArray([hole_color]))
	draw_polyline(spiral_points[spiral_rotation], spiral_color, 1)

func get_spiral_points(spiral_rotation):
	var points = PoolVector2Array()
	var num_coils = 2
	var center = Vector2(TEMP_START_POS.x, TEMP_START_POS.y)
	
	var theta_max = num_coils * 2 * PI
	var away_step = radius / theta_max
	var chord = 1
	
	points.push_back(center)
	
	var theta = chord /  away_step
	while theta < theta_max:
		var away = away_step * theta
		var around =  theta + spiral_rotation
		var next_x = center.x + cos(around) * away / curviness
		var next_y = center.y + sin(around) * away * curviness
		
		points.push_back(Vector2(next_x, next_y))
		
		theta += chord / away
	
	return points

func draw_circular_arc(center, radius, angle_from, angle_to, color, curviness, nb_points):
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var next_point = Vector2(cos(angle_point) * 1 / curviness, \
			sin(angle_point) * curviness) * radius
		points_arc.push_back(center + next_point)
#		draw_circle(center + next_point, 3, color)
	draw_colored_polygon(points_arc, color)

func _on_SpinTimer_timeout():
	spiral_rotation += 1
	if spiral_rotation == 6:
		spiral_rotation = 0
	if curviness >= max_curviness:
		curviness_direction = -1
	elif curviness <= min_curviness:
		curviness_direction = 1
	update()

func _on_Area2D_body_entered(body):
	print(body)
