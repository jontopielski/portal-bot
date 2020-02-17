extends Node2D

func _ready():
	replace_tile_with_portal($Portal1)
	replace_tile_with_portal($Portal2)

func _process(delta):
	var player_coordinates = $TileMap.world_to_map($Robo.position)
	var next_camera_position = Vector2((int(player_coordinates.x) / 16) * get_viewport().size.x,
			(int(player_coordinates.y) / 9) * get_viewport().size.y)
	if $Camera2D.position != next_camera_position:
		print("Updating camera position to: ", next_camera_position)
		$Camera2D.position = next_camera_position
		$SpaceBackground.position = next_camera_position

func replace_tile_with_portal(portal):
	var portal_coordinates = $TileMap.world_to_map(portal.position)
	var tile_at_position = $TileMap.get_cell(portal_coordinates.x, portal_coordinates.y)
	if tile_at_position != TileMap.INVALID_CELL:
		$TileMap.set_cellv(portal_coordinates, TileMap.INVALID_CELL)
	portal.position = $TileMap.map_to_world(portal_coordinates) + Vector2(5, 5)
