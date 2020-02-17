extends Node2D

const Portal = preload("res://src/gameplay/Portal.tscn")

var portal_info_prev = Globals.get_initial_portal_info()
var portal_info_next

func _ready():
	Globals.set_next_portal_info(Vector2(206, 74), Globals.PortalType.STANDARD)

func _process(delta):
	var player_tilemap_coordinates = $TileMap.world_to_map($Robo.position)
	handle_camera_positioning(player_tilemap_coordinates)
	handle_player_current_tile_logic(player_tilemap_coordinates)
	handle_player_below_tile_logic(player_tilemap_coordinates)
	handle_next_portal_info()

func handle_next_portal_info():
	portal_info_next = Globals.NextPortalInfo
	if !Globals.is_portal_info_same(portal_info_prev, portal_info_next):
		if Constants.DEBUG_MODE: print("Attempting to create portal at ", str(portal_info_next.pos))
		create_portal_at_position(portal_info_next.pos)
		portal_info_prev = portal_info_next

func create_portal_at_position(pos):
	var next_portal = Portal.instance()
	next_portal.position = pos
	add_child_below_node($Portals, next_portal)
	replace_tile_with_portal(next_portal)

func handle_player_below_tile_logic(player_tilemap_coordinates):
	var player_below_tilemap_coordinates = Vector2(player_tilemap_coordinates.x,
			player_tilemap_coordinates.y + 1)
	var player_below_tile_index = $TileMap.get_cell(player_below_tilemap_coordinates.x,
			player_below_tilemap_coordinates.y)
	if player_below_tile_index == Constants.TILE_SPIKE_INDEX:
		$Robo.set_next_state($Robo.fsm.states.Death)

func handle_player_current_tile_logic(player_tilemap_coordinates):
	var player_current_tile_index = $TileMap.get_cell(player_tilemap_coordinates.x,
			player_tilemap_coordinates.y)
	if player_current_tile_index == Constants.TILE_INACTIVE_SAVE_POINT_INDEX:
		if Constants.DEBUG_MODE: print("Found save point!")
		set_active_save_point(player_tilemap_coordinates)

func set_active_save_point(save_point_coordinates):
	$TileMap.set_cell(save_point_coordinates.x, save_point_coordinates.y,
			Constants.TILE_ACTIVE_SAVE_POINT_INDEX)
	$Robo.save_point_pos = $TileMap.map_to_world(save_point_coordinates)

func handle_camera_positioning(player_tilemap_coordinates):
	var next_camera_position = Vector2((int(player_tilemap_coordinates.x) / 16) * get_viewport().size.x,
			(int(player_tilemap_coordinates.y) / 9) * get_viewport().size.y)
	if $Camera2D.position != next_camera_position:
		if Constants.DEBUG_MODE: print("Updating camera position to: ", next_camera_position)
		$Camera2D.position = next_camera_position
		$SpaceBackground.position = next_camera_position

func replace_tile_with_portal(portal):
	var portal_coordinates = $TileMap.world_to_map(portal.position)
	var tile_at_position = $TileMap.get_cell(portal_coordinates.x, portal_coordinates.y)
	if tile_at_position != TileMap.INVALID_CELL:
		$TileMap.set_cellv(portal_coordinates, TileMap.INVALID_CELL)
	portal.position = $TileMap.map_to_world(portal_coordinates) + Vector2(5, 5)

func get_tile_center(tile_position):
	return Vector2(tile_position.x + 5, tile_position.y + 5)
