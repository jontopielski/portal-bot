extends Node2D

const speed = 100
var direction = 1

func _ready():
	pass

func _process(delta):
	$Particles2D.position.y += speed * direction * delta
	
	if $Particles2D.position.y < $TopPosition.position.y:
		direction = 1
	elif $Particles2D.position.y >= $BottomPosition.position.y:
		direction = -1
