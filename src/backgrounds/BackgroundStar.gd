extends Node2D

export var supershape_color := Color.white
export var supershape_scale = 10.0

export var supershape_np = 64
export var m := 5.0
export var n1 := 0.3
export var n2 := 0.3
export var n3 := 0.3

export var m_max = 6.0
export var m_min = 4.0
export var x_offset = 0
export var y_offset = 0

var supershape_points = PoolVector2Array()
var m_direction = 1
var move_counter = 0
var move_direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
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
	m += .1 * m_direction
	if m >= m_max:
		m_direction = -1
	elif m <= m_min:
		m_direction = 1
	fill_supershape_points()
	update()
