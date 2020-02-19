extends Node2D

const Portal = preload("res://src/gameplay/Portal.tscn")
const Flame = preload("res://src/things/Flame.tscn")
const CollectibleGun = preload("res://src/things/CollectibleGun.tscn")

var portal_info_prev = Globals.get_initial_portal_info()
var portal_info_next

var next_portal_vec_from_timer = Vector2.ZERO
var next_portal_type_from_timer = Globals.PortalType.STANDARD

var has_shown_first_portal_this_life = false

func _ready():
	$BlackBackground.show()
	$Camera2D/TransitionScreen.fade_out_of_point($Robo.position)

func _process(delta):
	var player_tilemap_coordinates = $TileMap.world_to_map($Robo.position)
	var camera_position = Vector2((int(player_tilemap_coordinates.x) / 16) * get_viewport().size.x,
			(int(player_tilemap_coordinates.y) / 9) * get_viewport().size.y)
	handle_camera_positioning_and_next_level(player_tilemap_coordinates, camera_position)
	handle_player_current_tile_logic(player_tilemap_coordinates)
	handle_player_below_tile_logic(player_tilemap_coordinates)
	handle_next_portal_info()

func handle_next_portal_info():
	portal_info_next = Globals.NextPortalInfo
	if !Globals.is_portal_info_same(portal_info_prev, portal_info_next):
		if Constants.DEBUG_MODE: print("Attempting to create portal at ", str(portal_info_next.coordinates))
		if Globals.PortalQueue.size() >= 2:
			Globals.pop_portal()
		create_portal_at_position(portal_info_next.coordinates)
		portal_info_prev = portal_info_next

func create_portal_at_position(coordinates):
	var next_portal = Portal.instance()
	next_portal.position = $TileMap.map_to_world(coordinates) + Vector2(5, 5)
	add_child_below_node($Portals, next_portal)
	Globals.push_portal(Globals.PortalInstance.new(Globals.PortalType.STANDARD, coordinates, $TileMap, next_portal))

func handle_player_below_tile_logic(player_tilemap_coordinates):
	var player_below_tilemap_coordinates = Vector2(player_tilemap_coordinates.x,
			player_tilemap_coordinates.y + 1)
	var player_below_tile_index = $TileMap.get_cell(player_below_tilemap_coordinates.x,
			player_below_tilemap_coordinates.y)
	if player_below_tile_index in Constants.DEATH_TILES:
		$Robo.cause_of_death = Globals.DeathCause.SPIKES
		$Robo.set_next_state($Robo.fsm.states.Death)

func handle_player_current_tile_logic(player_tilemap_coordinates):
	var player_current_tile_index = $TileMap.get_cell(player_tilemap_coordinates.x,
			player_tilemap_coordinates.y)
	if player_current_tile_index == Constants.TILE_INACTIVE_SAVE_POINT_INDEX:
		if Constants.DEBUG_MODE: print("Found save point!")
		set_active_save_point(player_tilemap_coordinates)
	elif player_current_tile_index == Constants.TILE_SIGN_INDEX:
		if Globals.CurrentRoom == Vector2(0, 0):
			$Camera2D.display_text_start(Constants.SIGN_NO_JUMPING)
		elif Globals.CurrentRoom == Vector2(4, 3):
			$Camera2D.display_text_start(Constants.SIGN_PRE_GUN)
		elif Globals.CurrentRoom == Vector2(7, 3):
			$Camera2D.display_text_start(Constants.SIGN_THIRD)
		elif Globals.CurrentRoom == Vector2(10, 5):
			$Camera2D.display_text_start(Constants.SIGN_FOURTH)
		elif Globals.CurrentRoom == Vector2(11, 5):
			$Camera2D.display_text_start(Constants.SIGN_FIVE)
	elif player_current_tile_index in Constants.DEATH_TILES:
		$Robo.cause_of_death = Globals.DeathCause.SPIKES
		$Robo.set_next_state($Robo.fsm.states.Death)
	if player_tilemap_coordinates == Vector2(25, 6) and ($Robo.save_point_pos == Constants.PLAYER_START_POSITION) \
			and $FirstPortalTimer.is_stopped() and !has_shown_first_portal_this_life:
		$FirstPortalTimer.start()
		has_shown_first_portal_this_life = true

func set_active_save_point(save_point_coordinates):
	$TileMap.set_cell(save_point_coordinates.x, save_point_coordinates.y,
			Constants.TILE_ACTIVE_SAVE_POINT_INDEX)
	$Robo.save_point_pos = $TileMap.map_to_world(save_point_coordinates)

func handle_camera_positioning_and_next_level(player_tilemap_coordinates, next_camera_position):
	if $Camera2D.position != next_camera_position:
		var room_next = Vector2(next_camera_position.x / 160, next_camera_position.y / 90)
#		Globals.CurrentRoom = room_next
		$Robo.is_on_cooldown = false
		if Constants.DEBUG_MODE:
			print("Updating camera position to: ", next_camera_position)
		handle_cleanup_prev_room(Globals.CurrentRoom)
#		$CleanupTimer.start()
		handle_prepare_next_room(room_next)
		Globals.CurrentRoom = room_next
		$Camera2D.position = next_camera_position
		$SpaceBackgrounds.position = next_camera_position
		$GeneratedStars.position = next_camera_position
#		var star_x_offset_based_on_room = 5
#		var star_y_offset_based_on_room = 5
#		update_star_position($BackgroundStar, next_camera_position, room_next)
#		update_star_position($BackgroundStar2, next_camera_position, room_next)
#		update_star_position($BackgroundStar3, next_camera_position, room_next)
#		update_star_position($BackgroundStar4, next_camera_position, room_next)
#		update_star_position($BackgroundStar5, next_camera_position, room_next)
		

func update_star_position(star, next_camera_position, room_next):
	star.position = Vector2(next_camera_position.x + star.x_offset - ((star.supershape_scale / 4.0) * room_next.x),
				next_camera_position.y + star.y_offset - ((star.supershape_scale / 4.0) * room_next.y))

func handle_cleanup_prev_room(room):
	if Constants.DEBUG_MODE: print("Cleaning up room ", str(room))
	match room:
		Vector2(0, 0):
			pass
		Vector2(1, 0):
			pass
		Vector2(3, 2):
			pass
		Vector2(3, 3):
			pass
	Globals.clear_portals()
	clear_flames()

func handle_prepare_next_room(room):
	if Constants.DEBUG_MODE: print("Preparing room ", str(room))
	match room:
		Vector2(0, 0):
			pass
		Vector2(1, 0):
			Globals.set_next_portal_info(Vector2(29, 1), Globals.PortalType.STANDARD)
#			Globals.set_next_portal_info(Vector2(20, 7), Globals.PortalType.STANDARD)
#			next_portal_vec_from_timer = Vector2(29, 1)
#			next_portal_type_from_timer = Globals.PortalType.STANDARD
#			$AddSecondPortalTimer.start() # Hack!
		Vector2(3, 1):
			create_flame_at_coordinates(Vector2(53, 16))
			
		Vector2(3, 2):
			var spawn_offset_x = 1
			var spawn_offset_y = -1
			var start_offset_x = 45
#			create_flame_at_coordinates(Vector2(start_offset_x + spawn_offset_x, 26 + spawn_offset_y))
			create_flame_at_coordinates(Vector2(start_offset_x + 1 + spawn_offset_x, 26 + spawn_offset_y))
			create_flame_at_coordinates(Vector2(start_offset_x + 2 + spawn_offset_x, 26 + spawn_offset_y))
			create_flame_at_coordinates(Vector2(start_offset_x + 3 + spawn_offset_x, 26 + spawn_offset_y))
			
#			create_flame_at_coordinates(Vector2(start_offset_x + 7 + spawn_offset_x, 26 + spawn_offset_y))
#			create_flame_at_coordinates(Vector2(start_offset_x + 8 + spawn_offset_x, 26 + spawn_offset_y))
#			create_flame_at_coordinates(Vector2(start_offset_x + 9 + spawn_offset_x, 26 + spawn_offset_y))
#			create_flame_at_coordinates(Vector2(start_offset_x + 11 + spawn_offset_x, 26 + spawn_offset_y))
			create_flame_at_coordinates(Vector2(start_offset_x + 12 + spawn_offset_x, 26 + spawn_offset_y))
			create_flame_at_coordinates(Vector2(start_offset_x + 13 + spawn_offset_x, 26 + spawn_offset_y))
			create_flame_at_coordinates(Vector2(start_offset_x + 14 + spawn_offset_x, 26 + spawn_offset_y))
			
#			spawn_offset_x = 0
#			spawn_offset_y = 0
#			create_flame_at_coordinates(Vector2(57, 25))
#			create_flame_at_coordinates(Vector2(58, 25))
#			create_flame_at_coordinates(Vector2(59, 25))
		Vector2(3, 3):
			var spawn_offset = 1
			var spawn_offset_y = -1
#			create_flame_at_coordinates(Vector2(56 + spawn_offset, 29 + spawn_offset_y))
#			create_flame_at_coordinates(Vector2(57 + spawn_offset, 29 + spawn_offset_y))
#			create_flame_at_coordinates(Vector2(58 + spawn_offset, 29 + spawn_offset_y))
#			create_flame_at_coordinates(Vector2(59 + spawn_offset, 29 + spawn_offset_y))
			
			Globals.set_next_portal_info(Vector2(50, 32), Globals.PortalType.STANDARD)
			next_portal_vec_from_timer = Vector2(61, 31)
			next_portal_type_from_timer = Globals.PortalType.STANDARD
			$AddSecondPortalTimer.start() # Hack!
		Vector2(5, 3):
			if $TileMap.get_cell(71, 33) == Constants.TILE_SIGN_INDEX:
				$TileMap.set_cell(71, 33, $TileMap.INVALID_CELL)
				var gun = CollectibleGun.instance()
				gun.gun_type = Globals.GunType.RED
				gun.position = $TileMap.map_to_world(Vector2(71, 33)) + Vector2(5, 5)
				add_child(gun)
		Vector2(6, 3):
			create_flame_at_coordinates(Vector2(102, 29))
			create_flame_at_coordinates(Vector2(105, 31))
		Vector2(9, 3):
			create_flame_at_coordinates(Vector2(146, 34))
			create_flame_at_coordinates(Vector2(147, 34))
			create_flame_at_coordinates(Vector2(148, 34))
			create_flame_at_coordinates(Vector2(149, 34))
			create_flame_at_coordinates(Vector2(150, 34))
			create_flame_at_coordinates(Vector2(151, 34))
			create_flame_at_coordinates(Vector2(152, 34))

func clear_flames():
	for flame in $Flames.get_children():
		flame.queue_free()

func create_flame_at_coordinates(coordinates):
	var flame = Flame.instance()
	var flame_position = $TileMap.map_to_world(coordinates) + Vector2(5, 5)
	flame.position = flame_position
	$Flames.add_child(flame)

func replace_tile_with_portal(portal):
	var portal_coordinates = $TileMap.world_to_map(portal.position)
	var tile_at_position = $TileMap.get_cell(portal_coordinates.x, portal_coordinates.y)
	if tile_at_position != TileMap.INVALID_CELL:
		$TileMap.set_cellv(portal_coordinates, TileMap.INVALID_CELL)
	portal.position = $TileMap.map_to_world(portal_coordinates) + Vector2(5, 5)

func get_tile_center(tile_position):
	return Vector2(tile_position.x + 5, tile_position.y + 5)

func _on_AddSecondPortalTimer_timeout():
	Globals.set_next_portal_info(next_portal_vec_from_timer, next_portal_type_from_timer)

func camera_fade_into_point(point):
	$Camera2D/TransitionScreen.fade_into_point(point)

func camera_fade_out_of_point(point):
	$Camera2D/TransitionScreen.fade_out_of_point(point)

func _on_CleanupTimer_timeout():
	Globals.clear_portals()
	clear_flames()

func _on_FirstPortalTimer_timeout():
	Globals.set_next_portal_info(Vector2(20, 7), Globals.PortalType.STANDARD)
