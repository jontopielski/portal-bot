extends KinematicBody2D

const starting_pos = Vector2(0, 0)
const turtle_skin_color = Color.white
const turtle_skin_color_secondary = Color.green
const turtle_shell_color = Color.black
const turtle_shell_design_color = Color.blue
const turtle_eye_color = Color.yellow

# Movement
var gravity = 0
var walk_speed = 80
var jump_speed = -1000
var velocity = Vector2()
var normal_vec = Vector2(0, 0)
export var is_moving_left = false
var is_in_shell = false

# Animation
var scale_rate = .05
var current_scale = 1
var scale_polarity = 1 # +1 or -1
var center_pos = Vector2(0, -10)

var current_state = State.IDLE

enum State {
	IDLE,
	WALKING,
	JUMPING,
	SHELL
}

enum LegState {
	FRONT,
	BACK
}

# Leg Animation
var leg_scale_rate_list = [1, 1, 1, 1]
var leg_current_scale_list = [0, 0, 0, 0]
var leg_scale_polarity_list = [1, -1, -1, 1]

func _ready():
	pass

func _process(delta):
	handle_states(delta)
	for i in range(0, 4):
		handle_leg_states(delta, i)
	update()

func _physics_process(delta):
	set_velocities(delta)
#	clamp_pos_to_screen()
	if is_colliding_with_rabbit() and !is_in_shell:
		go_into_shell()
		$ShellTimer.start()

func is_colliding_with_rabbit():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "Rabbit" in collision.collider.name:
			return true
	return false

func go_into_shell():
	is_in_shell = true
	center_pos.y += 10
	$CollisionShape2D.scale = Vector2(.8, .8)

func get_out_of_shell():
	is_in_shell = false
	center_pos.y -= 10
	$CollisionShape2D.scale = Vector2(1, 1)
	
func handle_states(delta):
	current_scale += scale_rate * delta * scale_polarity
	if current_scale < .98: # Fatter
		scale_polarity = 1
	elif current_scale > 1.05: # Thinner
		scale_polarity = -1
#		scale_rate = .1
	match current_state:
		State.IDLE:
			if is_in_shell:
				current_state = State.SHELL
			elif !is_on_floor():
				current_state = State.JUMPING
			elif is_walking():
				current_state = State.WALKING
		State.WALKING:
			if is_in_shell:
				current_state = State.SHELL
			elif !is_on_floor():
				current_state = State.JUMPING
			elif !is_walking():
				current_state = State.IDLE
		State.JUMPING:
			if is_on_floor():
				if is_walking():
					current_state = State.WALKING
				else:
					current_state = State.IDLE
		State.SHELL:
			pass

func handle_leg_states(delta, index):
	leg_current_scale_list[index] += leg_scale_rate_list[index] * delta * leg_scale_polarity_list[index]
	if leg_current_scale_list[index] < -1.25: # Forward
		leg_scale_polarity_list[index] = 1
		leg_scale_rate_list[index] = 2
	elif leg_current_scale_list[index] > 1.25: # Backwards
		leg_scale_polarity_list[index] = -1
		leg_scale_rate_list[index] = 2

func set_velocities(delta):
	velocity.x = 0
	velocity.y += gravity * delta
	if position.x < 200 and is_moving_left:
		is_moving_left = false
	elif position.x > 3800 and !is_moving_left:
		is_moving_left = true
	if is_in_shell:
		pass
	elif is_moving_left:
		velocity.x -= walk_speed
	else:
		velocity.x += walk_speed
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += walk_speed
#		is_moving_left = false
#		if is_in_shell:
#			get_out_of_shell()
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= walk_speed
#		is_moving_left = true
#		if is_in_shell:
#			get_out_of_shell()
#	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
#		velocity.y = jump_speed
#	if Input.is_action_pressed("ui_down") and !is_in_shell:
#		velocity.x = 0
#		velocity.y = 0
#		go_into_shell()
		
	velocity = move_and_slide_with_snap(velocity, Vector2(0, -1))
	if get_slide_count() > 0:
		normal_vec = get_slide_collision(0).normal
		var angle_delta = normal_vec.angle() - (rotation - (PI/2.0))
		rotation = angle_delta + rotation

func is_walking():
	if Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"):
		return true
	if !Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		return true
	return false

func clamp_pos_to_screen():
	var screen_size = get_viewport().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _draw():
	var turtle_body_length := 95
	if !is_in_shell:
		draw_turtle_head()
		draw_turtle_legs(turtle_body_length)
	draw_turtle_body(turtle_body_length)

func draw_turtle_head():
	var left_multiplier = -1 if is_moving_left else 1
	var head_offset = Vector2(80, 0)
	var head_radius = 18
#	draw_circle(Vector2(center_pos.x + (head_offset.x * left_multiplier), \
#		center_pos.y + head_offset.y), head_radius, turtle_skin_color)
	var head_pos = Vector2(center_pos.x + (head_offset.x * left_multiplier), \
		center_pos.y + head_offset.y)
	draw_circle_arc_trig_breathing(head_pos, head_radius, 0, 360, turtle_skin_color, .85, 8)
	
	# Neck
	var neck_pos_1 = Vector2(center_pos.x + (35 * left_multiplier), center_pos.y + 20)
	var neck_pos_2 = Vector2(center_pos.x + (55 * left_multiplier), center_pos.y + 15)
	var neck_pos_3 = Vector2(center_pos.x + (80 * left_multiplier), center_pos.y + 0)
	draw_circle(neck_pos_1, head_radius / 2, turtle_skin_color)
	draw_circle(neck_pos_2, head_radius / 2, turtle_skin_color)
#	draw_circle(neck_pos_3, head_radius / 2, turtle_skin_color)
	draw_line(neck_pos_1, neck_pos_2, turtle_skin_color, head_radius)
	draw_line(neck_pos_2, neck_pos_3, turtle_skin_color, head_radius)
	draw_line(neck_pos_3, head_pos, turtle_skin_color, head_radius)
	
	# Eyes
	var eyes_offset = Vector2(6, 4)
	var eyes_radius = 3.7
	var eye_position = Vector2(head_pos.x + (left_multiplier * eyes_offset.x), head_pos.y - eyes_offset.y)
	draw_circle_arc_trig(eye_position, eyes_radius, 0, 360, turtle_eye_color, 1, 8)

func draw_turtle_legs(turtle_body_length):
	var left_multiplier = -1 if is_moving_left else 1
	var center_to_legs_width = turtle_body_length * .4
	var center_to_legs_height = 20
	var back_leg_pos = Vector2(center_pos.x - (center_to_legs_width * left_multiplier), center_pos.y + center_to_legs_height)
	var front_leg_pos = Vector2(center_pos.x + (center_to_legs_width * left_multiplier), center_pos.y + center_to_legs_height)
	handle_leg_animations(front_leg_pos, back_leg_pos)
	draw_circle(back_leg_pos, 5, turtle_skin_color)
	draw_circle(front_leg_pos, 5, turtle_skin_color)

func handle_leg_animations(front_leg_pos, back_leg_pos):
	var leg_distance = 35.0
	var leg_radius = 10
	
	draw_leg_animation(front_leg_pos, leg_distance, get_leg_angle(0), turtle_skin_color_secondary, leg_radius)
	draw_leg_animation(front_leg_pos, leg_distance, get_leg_angle(1), turtle_skin_color, leg_radius)

	draw_leg_animation(back_leg_pos, leg_distance, get_leg_angle(2), turtle_skin_color_secondary, leg_radius)
	draw_leg_animation(back_leg_pos, leg_distance, get_leg_angle(3), turtle_skin_color, leg_radius)

func get_leg_angle(leg_number):
	var leg_current_scale_L = leg_current_scale_list[leg_number]
	leg_current_scale_L = max(leg_current_scale_L, -1.0)
	leg_current_scale_L = min(leg_current_scale_L, 1.0)
	var angle_to_return = deg2rad(leg_current_scale_L * 45.0)
	if angle_to_return == 0:
		angle_to_return = 0.001
		
	return angle_to_return

func draw_leg_animation(leg_pos, leg_distance, angle, color, rad):
	var leg_distance_x = leg_distance * sin(angle)
	var leg_distance_y  = leg_distance * cos(angle)
	var leg_pos_extended = Vector2(leg_pos.x + leg_distance_x, \
		leg_pos.y + leg_distance_y)
	draw_line(leg_pos, leg_pos_extended, color, rad)
	draw_circle(leg_pos_extended, rad, color)

func draw_turtle_body(turtle_body_length):
	draw_circle_arc_trig_breathing(center_pos, turtle_body_length * (4.75/10.0), \
	270, 90, turtle_skin_color, .8, 5) # Turtle Belly
	
	draw_circle_arc_trig(Vector2(center_pos.x, center_pos.y + 5), turtle_body_length/2.0, \
	-90, 90, turtle_shell_color, .8, 4) # Turtle Shell Top
	draw_circle_arc_trig(Vector2(center_pos.x, center_pos.y + 5), turtle_body_length/4.0, \
	270, 90, turtle_shell_color, .4, 4) # Turtle Shell Bottom
	
	draw_circle_arc_trig(Vector2(center_pos.x, center_pos.y + 5), turtle_body_length * (4.25/10.0), \
	-90, 90, turtle_shell_design_color, .8, 4) # Turtle Shell Design Top
	draw_circle_arc_trig(Vector2(center_pos.x, center_pos.y + 0), turtle_body_length * (2.125/10.0), \
	270, 90, turtle_shell_design_color, .4, 4) # Turtle Shell Design Bottom
	
	var shell_top_points = get_arc_points(Vector2(center_pos.x, center_pos.y + 5), turtle_body_length/2.0, \
	-90, 90, .8, 4)
	var shell_bottom_points = get_arc_points(Vector2(center_pos.x, center_pos.y + 5), turtle_body_length/4.0, \
	270, 90, .4, 5)
	var shell_design_inbetween_radius := 7.0
	
	for point in range(2, len(shell_bottom_points) - 2):
		draw_line(shell_top_points[point - 1] * .95, shell_bottom_points[point] * .75, turtle_shell_color, shell_design_inbetween_radius)
		draw_line(shell_top_points[point] * .95, shell_bottom_points[point] * .75, turtle_shell_color, shell_design_inbetween_radius)

func draw_circle_trig(pos, rad, col, trig):
	draw_circle_arc_trig(pos, rad, 0, 180, col, trig, Constants.CIRCLE_NB_POINTS)
	draw_circle_arc_trig(pos, rad, 180, 360, col, trig, Constants.CIRCLE_NB_POINTS)

func draw_circle_arc_trig(center, radius, angle_from, angle_to, color, trig_multiplier, nb_points):
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point) * 1 / trig_multiplier, sin(angle_point) * trig_multiplier) * radius)

	draw_colored_polygon(points_arc, color)

func draw_circle_arc_trig_breathing(center, radius, angle_from, angle_to, color, trig_multiplier, nb_points):
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point) * 1 / (trig_multiplier * current_scale), \
			sin(angle_point) * (trig_multiplier * current_scale)) * radius)

	draw_colored_polygon(points_arc, color)

func get_arc_points(center, radius, angle_from, angle_to, trig_multiplier, nb_points):
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point) * 1 / trig_multiplier, sin(angle_point) * trig_multiplier) * radius)
	
	return points_arc

func _on_AutomationTimer_timeout():
	is_moving_left = !is_moving_left

func _on_ShellTimer_timeout():
	if !is_colliding_with_rabbit():
		get_out_of_shell()
	else:
		$ShellTimer.start()
