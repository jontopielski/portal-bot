extends Node2D

var transition_color = Color.white
var transition_color_2 = Color.black
var curviness = 0.8
var nb_points = 8
var origin = Vector2.ZERO
var visible_counter = 0
var radius_increment = 15
var polyline_width = 25
var is_fading_to_black = true
var max_visible_circles = 10

func _ready():
	pass

func _draw():
	for i in range(0, visible_counter):
		if i == visible_counter - 1:
			draw_circular_arc_width(origin, (max_visible_circles * radius_increment) - radius_increment * i,
				0, 360, transition_color, curviness, 32, 5)
		else:
			draw_circular_arc(origin, (max_visible_circles * radius_increment) - radius_increment * i,
					0, 360, transition_color_2, curviness, nb_points)

func fade_into_point(point):
	origin = convert_to_local_position(point)
	visible_counter = 0
	$FadeToBlackTimer.start()
	
func fade_out_of_point(point):
	origin = convert_to_local_position(point)
	visible_counter = max_visible_circles
	$FadeToNormalTimer.start()

func convert_to_local_position(pos):
	return Vector2(pos.x - (Globals.CurrentRoom.x * 160), pos.y - (Globals.CurrentRoom.y * 90))

func draw_circular_arc(center, radius, angle_from, angle_to, color, curviness, nb_points):
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var next_point = Vector2(cos(angle_point) * 1 / curviness, \
			sin(angle_point) * curviness) * radius
		points_arc.push_back(center + next_point)
	draw_polyline(points_arc, color, polyline_width)

func draw_circular_arc_width(center, radius, angle_from, angle_to, color, curviness, nb_points, width):
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var next_point = Vector2(cos(angle_point) * 1 / curviness, \
			sin(angle_point) * curviness) * radius
		points_arc.push_back(center + next_point)
	draw_polyline(points_arc, color, width)

func _on_FadeToBlackTimer_timeout():
	visible_counter += 1
	update()
	if visible_counter >= max_visible_circles:
		$FadeToBlackTimer.stop()
		print("FTB Timer stopped")
	else:
		$FadeToBlackTimer.start()

func _on_FadeToNormalTimer_timeout():
	visible_counter -= 1
	update()
	if visible_counter <= 0:
		$FadeToNormalTimer.stop()
		print("FTN Timer stopped")
	else:
		$FadeToNormalTimer.start()
