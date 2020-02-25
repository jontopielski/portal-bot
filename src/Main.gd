extends Node2D

#onready var actions = get_node('actions')
#onready var reducers = get_node('reducers')
#onready var store = get_node('store')

export var is_muted = false

func _ready():
	if !is_muted:
		$SongStartTimer.start()

func play_main_music():
	if !is_muted:
		$MainMusic.play(0)
		$BossMusic.stop()
	$BossMusic.stop()

func stop_boss_music():
	$BossMusic.stop()

func play_boss_music():
	if !is_muted:
		$BossMusic.play(0)
	$MainMusic.stop()

func is_playing_main_music():
	return $MainMusic.is_playing()

func is_playing_boss_music():
	return $BossMusic.is_playing()

func play_checkpoint_sound():
	$SFX/CheckpointSound.play()

func play_pressure_on_sound():
	pass
#	$SFX/PressurePadOnSound.play()

func play_pressure_off_sound():
	pass
#	$SFX/PressurePadOffSound.play()


func _on_SongStartTimer_timeout():
	play_main_music()
