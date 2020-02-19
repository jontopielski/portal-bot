extends Area2D

const red_gun_sprite = preload("res://sprites/robo/red-gun-item.png")
const green_gun_sprite = preload("res://sprites/robo/green-gun-item.png")
const blue_gun_sprite = preload("res://sprites/robo/blue-gun-item.png")

export var gun_type = Globals.GunType.NONE

func _ready():
	match gun_type:
		Globals.GunType.RED:
			$Sprite.texture = red_gun_sprite
		Globals.GunType.GREEN:
			$Sprite.texture = green_gun_sprite
		Globals.GunType.BLUE:
			$Sprite.texture = blue_gun_sprite

func _on_SpinTimer_timeout():
	rotate(1)

func _on_CollectibleGun_body_entered(body):
	if body.name == "Robo":
		Globals.PlayerUnlockedGuns[gun_type] = true
		body.update_current_gun_type(gun_type)
		queue_free()
