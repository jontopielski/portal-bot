extends Node2D

const ShootingStar = preload("res://src/backgrounds/ShootingStar.tscn")

func _ready():
	pass

func _on_StarTimer_timeout():
	add_child(ShootingStar.instance())
