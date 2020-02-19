extends Node2D

export var supershape_color := Color.red
export var supershape_scale = 10.0

export var supershape_np = 64
export var m := 30.0
export var n1 := 0.4
export var n2 := 1.1
export var n3 := 0.5

export var m_max = 35
export var m_min = 30
export var is_movable = true
export var is_on_bullet = false

var supershape_points = PoolVector2Array()
var m_direction = 1
var move_counter = 0
var move_direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_on_bullet:
		$CollisionShape2D.queue_free()
	fill_supershape_points()

func _draw():
	draw_colored_polygon(supershape_points, supershape_color)

func fill_supershape_points():
	supershape_points = PoolVector2Array()
	for i in range(0, supershape_np + 1):
		var phi = i * (PI * 2) / supershape_np
		supershape_points.push_back(get_supershape_point(m,n1,n2,n3,phi) * supershape_scale)

func get_supershape_point(m, n1, n2, n3, phi):
	var vec = Vector2(0, 0)
	var r
	var t1
	var t2
	var a = 1
	var b = 1

	t1 = cos(m * phi / 4) / a
	t1 = abs(t1)
	t1 = pow(t1,n2)

	t2 = sin(m * phi / 4) / b
	t2 = abs(t2)
	t2 = pow(t2,n3)

	r = pow(t1+t2,1/n1)
	if abs(r) == 0:
		return vec
	else:
		r = 1 / r
		vec.x = r * cos(phi)
		vec.y = r * sin(phi)
		return vec

func _on_UITimer_timeout():
	m += 1 * m_direction
	if m >= m_max:
		m_direction = -1
	elif m <= m_min:
		m_direction = 1
	fill_supershape_points()
	update()

func _on_MoveTimer_timeout():
	if !is_movable:
		return
	move_counter += 1 * move_direction
	position.x += 10 * move_direction
	if move_counter >= 4:
		move_direction = -1
	elif move_counter <= 0:
		move_direction = 1

func _on_Flame_body_entered(body):
	if body.name == "Robo" and !is_on_bullet:
		if body.fsm.state_curr != body.fsm.states.WarpOut and body.fsm.state_curr != body.fsm.states.WarpIn:
			body.cause_of_death = Globals.DeathCause.FLAMES
			body.fsm.state_next = body.fsm.states.Death
