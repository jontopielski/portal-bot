extends KinematicBody2D

const Bullet = preload("res://src/things/Bullet.tscn")
const GunSmoke = preload("res://src/things/GunSmoke.tscn")

var vel = Vector2()

var dir_next = 1

var anim_curr = ""
var anim_next = ""

var save_point_pos = Constants.PLAYER_START_POSITION
var cause_of_death = Globals.DeathCause.NONE
export var current_gun_type = Globals.GunType.RED
var is_on_cooldown = false

onready var rotate = $Rotate
onready var arm = $Arm
onready var fsm = FSM.new(self, $States, $States/Idle, true)

func _ready():
	show_gun()

func _physics_process(delta):
	fsm.run_machine(delta)
	set_direction()
	
	if anim_curr != anim_next:
		anim_curr = anim_next
		$AnimationPlayer.play(anim_curr)

	if dir_next != rotate.scale.x:
		rotate.scale.x = dir_next
	
	if Input.is_action_pressed("ui_click") and !is_on_cooldown and current_gun_type != Globals.GunType.NONE:
		handle_mouse_click(get_global_mouse_position())
	if Input.is_action_pressed("ui_restart"):
		fsm.state_next = fsm.states.Death
		if save_point_pos == Constants.PLAYER_START_POSITION:
			get_parent().has_shown_first_portal_this_life = false
	
func set_direction():
	var mouse_offset = get_global_mouse_position() - global_position
	
	if mouse_offset.x > 0:
		dir_next = 1
		$Arm.scale.y = 1
	elif mouse_offset.x < 0:
		dir_next = -1
		$Arm.scale.y = -1
	
	$Arm.rotation = mouse_offset.angle()

func set_next_state(state):
	fsm.state_next = state

func update_current_gun_type(gun_type):
	current_gun_type = gun_type
	show_gun()

func show_gun():
	$Arm/GreenGun.hide()
	$Arm/RedGun.hide()
	$Arm/BlueGun.hide()
	match current_gun_type:
		Globals.GunType.RED:
			$Arm/RedGun.show()
		Globals.GunType.BLUE:
			$Arm/BlueGun.show()
		Globals.GunType.GREEN:
			$Arm/GreenGun.show()

func handle_mouse_click(mouse_position):
	var player_position = Vector2(position.x, position.y - 1)
	var mouse_normal = player_position.direction_to(mouse_position)
	var mouse_distance = player_position.distance_to(mouse_normal)
	var rotated_normal = mouse_normal.rotated(deg2rad(0))
	var rotated_position = rotated_normal * mouse_distance
	
	is_on_cooldown = true
	$ShotCooldownTimer.start()
	fire_bullet_at_pos(rotated_normal * 10, rotated_normal, player_position, false)
#	fire_bullet_at_pos(rotated_normal * 10, rotated_normal, player_position, true)
#	fire_bullet_at_pos(rotated_normal * 10, rotated_normal, player_position, true)
	
	add_gunsmoke_at_pos(rotated_normal * 7.5 + player_position)

func fire_bullet_at_pos(spawn_position, target_position, player_position, is_decorative_bullet):
	spawn_position += player_position
	target_position += player_position
	var mouse_offset = get_global_mouse_position() - global_position
	var next_bullet = Bullet.instance()
	next_bullet.set_position(spawn_position)
	next_bullet.set_target_position(target_position)
	next_bullet.is_decorative_bullet = is_decorative_bullet
	next_bullet.rotation = mouse_offset.angle() + PI/2.0
	get_parent().add_child(next_bullet)

func add_gunsmoke_at_pos(pos):
	var gunsmoke = GunSmoke.instance()
	gunsmoke.set_position(pos)
	get_parent().add_child(gunsmoke)

func _on_ShotCooldownTimer_timeout():
	is_on_cooldown = false

func fade_in():
	get_parent().camera_fade_into_point(position)

func fade_out():
	get_parent().camera_fade_out_of_point(position)
