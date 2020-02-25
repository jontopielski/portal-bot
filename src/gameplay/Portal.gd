extends Node2D

const hole_color = Color.black
var spiral_color = Color.red

var TEMP_START_POS = Vector2(0, 0)
var radius = 5
var spiral_rotation = 0
var spiral_points = []
var portal_type = Globals.PortalType.STANDARD
var coordinates = Vector2.ZERO

var is_special = false

func _ready():
	$PortalCreatedSound.play()
	scale = Vector2.ZERO
	for i in range(0, 6):
		spiral_points.push_back(get_spiral_points(i));
	spiral_color = Globals.PlayerGunColor

func update_spiral_color():
	match spiral_color:
		Color.red:
			spiral_color = Color.green
		Color.green:
			spiral_color = Color.blue
		Color.blue:
			spiral_color = Color.red

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
		var next_x = center.x + cos(around) * away
		var next_y = center.y + sin(around) * away
		
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
	draw_colored_polygon(points_arc, color)

func _on_SpinTimer_timeout():
	if is_special:
		update_spiral_color()
	spiral_rotation += 1
	if spiral_rotation == 6:
		spiral_rotation = 0
	update()

func _on_Area2D_body_entered(body):
	var portalable_bodies = ["Robo", "Box", "Snake"]
	for portalable_body in portalable_bodies:
		if portalable_body in body.name:
			if "SnakeCharmer" in body.name:
				return
			body.position = position
#			Globals.set_last_portal_coordinates_from_pos(position)
			if body.fsm.state_curr != body.fsm.states.WarpOut and body.fsm.state_curr != body.fsm.states.WarpIn:
				if "Robo" in body.name and body.fsm.state_curr == body.fsm.states.Death:
					return
				else:
					if is_special:
						Globals.HasWarpedIntoSpecialPortal = true
						$FinalPortal.play()
					$WarpIn.play()
					body.last_portal_coordinates = coordinates
					body.fsm.state_next = body.fsm.states.WarpIn


func _on_ExpandTimer_timeout():
	scale += Vector2(.1, .1)
	if scale >= Vector2(1, 1):
		scale = Vector2(1, 1)
		$ExpandTimer.stop()
