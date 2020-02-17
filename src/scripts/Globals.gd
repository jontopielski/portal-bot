extends Node

enum GameState {
	INTRO,
	MAIN_GAME,
	PAUSED,
	END_GAME
}

enum PortalType {
	STANDARD
}

var PortalQueue = []
var NextPortalInfo = get_initial_portal_info()
var NextPortalPosition = Vector2.ZERO
var NextPortalType = PortalType.STANDARD

func set_next_portal_info(pos, type):
	NextPortalInfo = PortalInfo.new(pos, type)

func get_initial_portal_info():
	var info = PortalInfo.new(Vector2.ZERO, PortalType.STANDARD)
	return info

func is_portal_info_same(info_one, info_two):
	if info_one.pos.x == info_two.pos.x and info_one.pos.y == info_two.pos.y \
			and info_one.type == info_two.type:
		return true
	else:
		return false

class PortalInfo:
	var pos = Vector2.ZERO
	var type = PortalType.STANDARD
	
	func _init(p, t):
		pos = p
		type = t

func clear_portals():
	for portal in PortalQueue:
		portal.tilemap.set_cell(portal.tilemap_coordinates.x,
				portal.tilemap_coordinates.y, portal.overwritten_tile_index)
	PortalQueue.clear()

func push_portal(portal):
	PortalQueue.push_back(portal)

class PortalInstance:
	var type = PortalType.STANDARD
	var pos = Vector2.ZERO
	var tilemap_coordinates = Vector2.ZERO
	var tilemap = null
	var overwritten_tile_index = -1
	
	func _init(portal_type, portal_position, tilemap, portal_tilemap_coordinates,
			portal_overwritten_tile_index):
		type = portal_type
		pos = portal_position
		tilemap_coordinates = portal_tilemap_coordinates
		overwritten_tile_index = portal_overwritten_tile_index
