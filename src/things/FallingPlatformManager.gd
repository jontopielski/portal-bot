extends Node2D

enum State {
	NOT_STARTED,
	FIRST_TILE,
	SECOND_TILE,
	HIDDEN
}

var current_state = State.NOT_STARTED
var tilemap_ref
var platform_coordinates
var room

func _process(delta):
	if room != Globals.CurrentRoom and current_state != State.NOT_STARTED:
		tilemap_ref.set_cell(platform_coordinates.x, platform_coordinates.y, Constants.TILE_FALLING_PLATFORM_1)
		current_state = State.NOT_STARTED
	if current_state == State.HIDDEN and $RespawnTimer.is_stopped():
		$RespawnTimer.start()

func is_on_portal():
	for portal in Globals.PortalQueue:
		if portal.tilemap_coordinates == platform_coordinates:
			return true
	return false

func instantiate(tilemap, coordinates, platform_room):
	tilemap_ref = tilemap
	platform_coordinates = coordinates
	room = platform_room
	tilemap_ref.set_cell(platform_coordinates.x, platform_coordinates.y, Constants.TILE_FALLING_PLATFORM_1)

func reset():
	tilemap_ref.set_cell(platform_coordinates.x, platform_coordinates.y, Constants.TILE_FALLING_PLATFORM_1)
	current_state = State.NOT_STARTED
	$Timer.stop()
	$RespawnTimer.stop()
	$BackTo1Timer.stop()

func hide():
	tilemap_ref.set_cell(platform_coordinates.x, platform_coordinates.y, -1)
	current_state = State.HIDDEN
	$Timer.stop()
	$RespawnTimer.stop()
	$BackTo1Timer.stop()

func terminate():
	pass

func start_if_not_started():
	if has_started():
		return
	else:
		current_state = State.FIRST_TILE
		$Timer.start()

func has_started():
	return current_state != State.NOT_STARTED

func _on_Timer_timeout():
	if is_on_portal():
		hide()
		return
	if current_state == State.FIRST_TILE:
		current_state = State.SECOND_TILE
		tilemap_ref.set_cell(platform_coordinates.x, platform_coordinates.y, Constants.TILE_FALLING_PLATFORM_2)
		$Timer.start()
	elif current_state == State.SECOND_TILE:
		current_state = State.HIDDEN
		tilemap_ref.set_cell(platform_coordinates.x, platform_coordinates.y, -1)
		$RespawnTimer.start()

func _on_RespawnTimer_timeout():
	if is_on_portal():
		hide()
		return
	tilemap_ref.set_cell(platform_coordinates.x, platform_coordinates.y, Constants.TILE_FALLING_PLATFORM_2)
	current_state = State.SECOND_TILE
	$BackTo1Timer.start()

func _on_BackTo1Timer_timeout():
	if is_on_portal():
		hide()
		return
	tilemap_ref.set_cell(platform_coordinates.x, platform_coordinates.y, Constants.TILE_FALLING_PLATFORM_1)
	current_state = State.NOT_STARTED
