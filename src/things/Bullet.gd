extends Area2D

const GRAVITY = 1800.0
const FRICTION = 0.1
const ACCELERATION = 50
const SPEED = 100

var target_normal = Vector2(0, 0)
var velocity = Vector2(0, 0)

export var bullet_color = Color.white
export var gun_type = Globals.GunType.NONE
export var is_decorative_bullet = false

func _ready():
	update_flame_color()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, Vector2(1, 3)), bullet_color, true)

func _physics_process(delta):
	velocity = -target_normal * SPEED * delta
	position += velocity
	if global_position.x < (Globals.CurrentRoom.x * 160) or global_position.x > (Globals.CurrentRoom.x * 160) + 160:
		queue_free()
	if global_position.y < (Globals.CurrentRoom.y * 90) or global_position.y > (Globals.CurrentRoom.y * 90) + 90:
		queue_free()

func set_position(pos):
	position = pos

func set_target_position(pos):
	target_normal = position.direction_to(pos)

func update_flame_color():
	match gun_type:
		Globals.GunType.RED:
			$Flame.supershape_color = Color.red
		Globals.GunType.GREEN:
			$Flame.supershape_color = Color.green
		Globals.GunType.BLUE:
			$Flame.supershape_color = Color.blue

func _on_Bullet_area_entered(area):
	print("Area collider")
	print(area.name)

func _on_Bullet_body_entered(body):
	if is_decorative_bullet:
		queue_free()
	print(body.name)
	if body.name == "TileMap":
		print("bullet position: ", position)
		var forward_position = position
#		var forward_position = position - (target_normal * 1)
		print("forward position: ", forward_position)
		var coordinates = body.world_to_map(forward_position)
		var collided_tile_index = body.get_cell(coordinates.x, coordinates.y)
		if !(collided_tile_index in Constants.BULLET_TILE_INDEX_BLACKLIST):
			if Constants.DEBUG_MODE:
				print("Bullet collided with tile index ", str(collided_tile_index))
			Globals.set_next_portal_info(coordinates, get_portal_type())
		queue_free()

func get_portal_type():
	match gun_type:
		Globals.GunType.RED:
			return Globals.PortalType.STANDARD
		Globals.GunType.GREEN:
			return Globals.PortalType.GRAVITY
		Globals.GunType.BLUE:
			return Globals.PortalType.BLUE

func set_portal_type():
	match gun_type:
		Globals.GunType.RED:
			Globals.LastPortalType = Globals.PortalType.STANDARD
		Globals.GunType.GREEN:
			Globals.LastPortalType = Globals.PortalType.GRAVITY
		Globals.GunType.BLUE:
			Globals.LastPortalType = Globals.PortalType.BLUE
