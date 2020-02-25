extends KinematicBody2D

const Snake = preload("res://src/snake/Snake.tscn")
const GunSmoke = preload("res://src/things/GunSmoke.tscn")
const CastBeam = preload("res://src/snakecharmer/CastBeam.tscn")
const CastMissile = preload("res://src/snakecharmer/CastMissile.tscn")
const SNAKECHARMER_ROOM = Vector2(3, 4)

enum WaveType {
	NORMAL,
	WIDE
}

enum CastType {
	RED,
	GREEN,
	BLUE
}

enum CornerPosition {
	BottomLeft,
	BottomRight,
	TopLeft,
	TopRight
}

var vel = Vector2()

var dir_next = 1

var anim_curr = ""
var anim_next = ""
var warning_cast_count = 0

onready var rotate = $Rotate
onready var fsm = FSM.new(self, $States, $States/Idle, true)
onready var jar = $Rotate/Jar

var chapter_two_ref = null
var current_corner_position = CornerPosition.BottomRight
var last_corner_position = CornerPosition.TopRight
var tilemap = null
var top_left_coordinates = Vector2.ZERO
var top_right_coordinates = Vector2.ZERO
var bottom_left_coordinates = Vector2.ZERO
var bottom_right_coordinates = Vector2.ZERO
var state_counter = 0
var cast_counter = 0
var health = 6

var is_dead = false

var last_cast_type = CastType.BLUE
var curr_cast_type = CastType.RED
var damage_ui_update_counter = 0

func stop_all_attacks():
	$CastWarningTimer.stop()

func _ready():
	set_wave_to_normal()
	hide_jar()

func show_jar():
	jar.show()

func hide_jar():
	jar.hide()

func stop_boss_music():
	chapter_two_ref.stop_boss_music()

func play_disappear_sound():
	$DisappearSound.play()	

func release_door_and_free():
	chapter_two_ref.release_tile_62_42()
	queue_free()

func take_damage():
	$TakeDamageSound.play()
	health -= 1
	handle_take_damage_UI()
	if health == 0:
		Globals.HasDefeatedBoss = true
		is_dead = true
		$CrySound.play()
		print("SNAKECHARMER IS DEAD")
		fsm.state_next = fsm.states.Death
	else:
		pass

func handle_take_damage_UI():
	damage_ui_update_counter = 0
	$DamageUITimer.start()

func start_state_switch_timer():
	$StateSwitchTimer.start()

func _physics_process(delta):
	fsm.run_machine(delta)
	set_direction()
	
	if anim_curr != anim_next:
		anim_curr = anim_next
		$AnimationPlayer.play(anim_curr)

	if dir_next != rotate.scale.x:
		rotate.scale.x = dir_next

func start_cast_warning():
	warning_cast_count = 0
	$CastWarningTimer.start()

func cast_warning(color):
	create_cast_beam(color)

func get_next_cast_type():
	match last_cast_type:
		CastType.RED:
			return choose_random_cast_type(CastType.GREEN, CastType.BLUE)
		CastType.GREEN:
			return choose_random_cast_type(CastType.RED, CastType.BLUE)
		CastType.BLUE:
			return choose_random_cast_type(CastType.RED, CastType.GREEN)

func choose_random_cast_type(cast_type_one, cast_type_two):
	randomize()
	var rand = randi() % 2
	if rand == 0:
		return cast_type_one
	else:
		return cast_type_two

func update_next_cast_type():
	curr_cast_type = get_next_cast_type()

func cast_attack():
	if is_dead:
		return
	$ShootSound.play()
	match curr_cast_type:
		CastType.RED:
			cast_red_attack()
		CastType.GREEN:
			cast_green_attack()
		CastType.BLUE:
			cast_blue_attack()

func increment_cast_counter():
	cast_counter += 1

func cast_red_attack():
	fire_cast_missile_at_player()
	last_cast_type = CastType.RED

func cast_green_attack():
	chapter_two_ref.randomize_falling_platforms_on_boss_fight()
	last_cast_type = CastType.GREEN

func cast_blue_attack():
	fire_cast_missile_towards_player_direction()
	last_cast_type = CastType.BLUE

func fire_cast_missile_at_player():
	var next_cast_missile = CastMissile.instance()
	var castbeam_position = Vector2.ZERO
	if rotate.scale.x == -1:
		castbeam_position = global_position - Vector2(13, 10)
	else:
		castbeam_position = global_position + Vector2(13, 10)
	next_cast_missile.set_position(castbeam_position)
	next_cast_missile.set_target_position(Globals.PlayerPosition)
	next_cast_missile.set_flame_color(Color.red)
	next_cast_missile.rotation = (position - Globals.PlayerPosition).angle() + PI/2.0
	$CastMissiles.add_child(next_cast_missile)

func fire_cast_missile_towards_player_direction():
	var next_cast_missile = CastMissile.instance()
	var castbeam_position = Vector2.ZERO
	randomize()
	var rand_scale = randi() % 2
	if rand_scale == 0:
		rand_scale = -1
	else:
		rand_scale = 1
	if rotate.scale.x == -1:
		castbeam_position = global_position - Vector2(13, -5 * rand_scale)
	else:
		castbeam_position = global_position + Vector2(13, -5 * rand_scale)
	next_cast_missile.set_position(castbeam_position)
	next_cast_missile.set_speed(50)
	if rotate.scale.x == -1:
		next_cast_missile.set_target_position(Vector2(position.x - 50, position.y))
	else:
		next_cast_missile.set_target_position(Vector2(position.x + 50, position.y))
	next_cast_missile.set_horizontal_missile(true)
	next_cast_missile.set_flame_color(Color.blue)
	next_cast_missile.rotation = (position - Globals.PlayerPosition).angle() + PI/2.0
	$CastMissiles.add_child(next_cast_missile)

func create_cast_beam(color):
	var castbeam = CastBeam.instance()
	var castbeam_position = Vector2.ZERO
	if rotate.scale.x == -1:
		castbeam_position = global_position - Vector2(13, 10)
	else:
		castbeam_position = global_position + Vector2(13, -10)
	castbeam.set_color(color)
	castbeam.position = castbeam_position
	$CastBeams.add_child(castbeam)

func summon_snake():
	if is_dead:
		return
	var snake = Snake.instance()
	var snake_position = Vector2.ZERO
	if rotate.scale.x == -1:
		snake_position = global_position - Vector2(13, -1)
	else:
		snake_position = global_position + Vector2(13, -1)
	snake.set_spawn_position(snake_position)
	snake.set_room(SNAKECHARMER_ROOM)
	add_gunsmoke_at_pos(snake_position)
	$Snakes.add_child(snake)

func add_gunsmoke_at_pos(pos):
	var gunsmoke = GunSmoke.instance()
	gunsmoke.set_position(pos)
	$GunSmoke.add_child(gunsmoke)

func is_in_corner():
	return current_corner_position == CornerPosition.BottomLeft or current_corner_position == CornerPosition.BottomRight

func set_corner_position_coordinates(tilemap_ref, top_left_coordinates_ref, top_right_coordinates_ref, \
			bottom_left_coordinates_ref, bottom_right_coordinates_ref):
	tilemap = tilemap_ref
	top_left_coordinates = top_left_coordinates_ref
	top_right_coordinates = top_right_coordinates_ref
	bottom_left_coordinates = bottom_left_coordinates_ref
	bottom_right_coordinates = bottom_right_coordinates_ref

func update_corner_positions():
	var next_corner_position
	match current_corner_position:
		CornerPosition.BottomLeft:
			next_corner_position = last_corner_position
		CornerPosition.BottomRight:
			next_corner_position = last_corner_position
		CornerPosition.TopLeft:
			if last_corner_position == CornerPosition.BottomLeft:
				next_corner_position = CornerPosition.TopRight
			else:
				next_corner_position = CornerPosition.BottomLeft
		CornerPosition.TopRight:
			if last_corner_position == CornerPosition.BottomRight:
				next_corner_position = CornerPosition.TopLeft
			else:
				next_corner_position = CornerPosition.BottomRight
	if Constants.DEBUG_MODE:
		print("Setting CurrentCornerPosition to ", str(next_corner_position))
	last_corner_position = current_corner_position
	current_corner_position = next_corner_position

func get_current_corner_position():
	match current_corner_position:
		CornerPosition.BottomLeft:
			return tilemap.map_to_world(bottom_left_coordinates) + Vector2(5, 5)
		CornerPosition.BottomRight:
			return tilemap.map_to_world(bottom_right_coordinates) + Vector2(5, 5)
		CornerPosition.TopLeft:
			return tilemap.map_to_world(top_left_coordinates) + Vector2(5, 5)
		CornerPosition.TopRight:
			return tilemap.map_to_world(top_right_coordinates) + Vector2(5, 5)

func set_direction():
	var player_offset = Globals.PlayerPosition - global_position
	
	if player_offset.x > 0:
		dir_next = 1
	elif player_offset.x < 0:
		dir_next = -1

func _draw():
	draw_wave()

func draw_wave():
	var last_point = null
	for i in range(0, 5):
		var next_index = (circle_index + i) % circle_points.size()
		var next_circle_point = circle_points[next_index]
		var center_distance_x = cos(circle_angles[next_index]) * Vector2(16, 16).distance_to(next_circle_point)
		var circle_offset_x = i
		var next_point = Vector2(next_circle_point.x + circle_offset_x - center_distance_x, \
			next_circle_point.y)
		draw_circle(next_point, 1, Color.black)
		wave_vectors.insert(i, next_point)
		if last_point != null:
			draw_line(last_point, next_point, Color.white, 1)
		last_point = next_point
		wave_count += 1

func draw_normal_wave():
	pass

func set_wave_to_normal():
	wave_type = WaveType.NORMAL
	circle_index = 0
	circle_rad = 2
	circle_angle_from = 0
	circle_angle_to = 360
	circle_curviness = 2.0
	circle_nb_points = 10
	circle_angle_from = 360.0 / circle_nb_points
	circle_points = get_circular_arc_points(wave_offset, circle_rad, circle_angle_from, \
		circle_angle_to, circle_curviness, circle_nb_points)
	circle_angles = get_circular_arc_angles(wave_offset, circle_rad, circle_angle_from, \
		circle_angle_to, circle_curviness, circle_nb_points)
	update()

func set_wave_to_wide():
	wave_type = WaveType.WIDE
	circle_index = 0
	circle_rad = 2.5
	circle_angle_from = 0
	circle_angle_to = 360
	circle_curviness = 4.0
	circle_nb_points = 20
	circle_angle_from = 360.0 / circle_nb_points
	circle_points = get_circular_arc_points(wave_offset, circle_rad, circle_angle_from, \
		circle_angle_to, circle_curviness, circle_nb_points)
	circle_angles = get_circular_arc_angles(wave_offset, circle_rad, circle_angle_from, \
		circle_angle_to, circle_curviness, circle_nb_points)
	update()

func set_wave_to_death():
	wave_type = WaveType.WIDE
	circle_index = 0
	circle_rad = 1.0
	circle_angle_from = 0
	circle_angle_to = 360
	circle_curviness = .5
	circle_nb_points = 50
	circle_angle_from = 360.0 / circle_nb_points
	circle_points = get_circular_arc_points(wave_offset, circle_rad, circle_angle_from, \
		circle_angle_to, circle_curviness, circle_nb_points)
	circle_angles = get_circular_arc_angles(wave_offset, circle_rad, circle_angle_from, \
		circle_angle_to, circle_curviness, circle_nb_points)
	update()

var circle_index = 0
var circle_rad = 2
var circle_angle_from = 0
var circle_angle_to = 360
var circle_curviness = 2.0
var circle_nb_points = 10

var circle_points = PoolVector2Array()
var circle_angles = PoolVector2Array()

var wave_vectors = PoolVector2Array()
var wave_count = 0
var position_offset = Vector2(0, 0)

var wave_type = WaveType.NORMAL
var wave_offset = Vector2(0, 10)

func get_circular_arc_points(center, radius, angle_from, angle_to, curviness, nb_points):
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var next_point = Vector2(cos(angle_point) * 1 / curviness, \
			sin(angle_point) * curviness) * radius
		points_arc.push_back(center + next_point)
	return points_arc

func get_circular_arc_angles(center, radius, angle_from, angle_to, curviness, nb_points):
	var angles_vector = []
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var next_point = Vector2(cos(angle_point) * 1 / curviness, \
			sin(angle_point) * curviness) * radius
		angles_vector.push_back(angle_point)
	return angles_vector

func _on_WaveTimer_timeout():
	circle_index += 1
	if circle_index == circle_points.size():
		circle_index = 0
	update()

func _on_StateSwitchTimer_timeout():
	state_counter += 1
	if state_counter % 3 == 0:
		fsm.state_next = fsm.states.Move
	else:
		if cast_counter % 3 == 1:
			fsm.state_next = fsm.states.Summon
		else:
			fsm.state_next = fsm.states.Cast

func _on_CastWarningTimer_timeout():
	match curr_cast_type:
		CastType.RED:
			$PrepareCastSound.play()
			cast_warning(Color.red)
		CastType.GREEN:
			$PrepareCastSoundGreen.play()
			cast_warning(Color.green)
		CastType.BLUE:
			$PrepareCastSoundBlue.play()
			cast_warning(Color.blue)
	warning_cast_count += 1
	if warning_cast_count == 5:
		$CastWarningTimer.stop()
		warning_cast_count = 0

func _on_DamageUITimer_timeout():
	if $Rotate.visible:
		$Rotate.hide()
	else:
		$Rotate.show()
	
	damage_ui_update_counter += 1
	if damage_ui_update_counter >= 5:
		$Rotate.show()
		$DamageUITimer.stop()


func _on_Area2D_body_entered(body):
	if body.name == "Robo" and !is_dead:
		if body.fsm.state_curr != body.fsm.states.WarpOut and body.fsm.state_curr != body.fsm.states.WarpIn:
			body.cause_of_death = Globals.DeathCause.FLAMES
			body.fsm.state_next = body.fsm.states.Death
