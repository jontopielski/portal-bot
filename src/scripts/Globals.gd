extends Node

enum GameState {
	INTRO,
	MAIN_GAME,
	PAUSED,
	END_GAME
}

enum DeathCause {
	SPIKES,
	FLAMES,
	NONE
}

enum GunType {
	RED,
	GREEN,
	BLUE,
	NONE
}

enum PortalType {
	STANDARD,
	GRAVITY,
	BLUE
}

var PlayerUnlockedGuns = {
	GunType.RED: true,
	GunType.GREEN: false,
	GunType.BLUE: false
}

var PortalQueue = []
var NextPortalInfo = get_initial_portal_info()
var LastPortalCoordinates = Vector2.ZERO
#var LastPortalType = PortalType.STANDARD
var CurrentRoom = Vector2.ZERO
var PlayerPosition = Vector2.ZERO

var PlayerGunColor = Color.red

var HasDefeatedBoss = false
var HasWarpedIntoSpecialPortal = false

func get_next_portal_position(last_portal_coordinates, allow_same):
	if PortalQueue.size() == 0:
		print("TRYING TO GET A PORTAL FROM AN EMPTY QUEUE!")
		return Vector2.ZERO
	if allow_same and PortalQueue.size() == 1:
		var same_portal = PortalQueue.front()
		return same_portal.tilemap.map_to_world(same_portal.tilemap_coordinates) + Vector2(5, 5)
	if PortalQueue.size() >= 2:
		for portal in PortalQueue:
#			if portal.type != LastPortalType:
#				continue
			if last_portal_coordinates == portal.tilemap_coordinates:
				continue
			else:
				return portal.tilemap.map_to_world(portal.tilemap_coordinates) + Vector2(5, 5)

func set_last_portal_coordinates_from_pos(pos):
	for portal in PortalQueue:
		var last_pos_tilemap_coordinates = portal.tilemap.world_to_map(pos)
		if last_pos_tilemap_coordinates == portal.tilemap_coordinates:
			Globals.LastPortalCoordinates = last_pos_tilemap_coordinates

func set_last_portal_type(type):
	Globals.LastPortalType = type

func set_next_portal_info(coordinates, type):
	NextPortalInfo = PortalInfo.new(coordinates, type)

func get_initial_portal_info():
	var info = PortalInfo.new(Vector2.ZERO, PortalType.STANDARD)
	return info

func is_portal_info_same(info_one, info_two):
	if info_one.coordinates.x == info_two.coordinates.x and \
			info_one.coordinates.y == info_two.coordinates.y:
		return true
	else:
		return false

class PortalInfo:
	var coordinates = Vector2.ZERO
	var type = PortalType.STANDARD
	
	func _init(c, t):
		coordinates = c
		type = t

func clear_portals():
	for portal in PortalQueue:
		portal.tilemap.set_cell(portal.tilemap_coordinates.x,
				portal.tilemap_coordinates.y, portal.overwritten_tile_index)
		portal.object_ref.queue_free()
	PortalQueue.clear()

func pop_portal():
	if PortalQueue.size() == 0:
		return
	var top_portal = PortalQueue.pop_front()
	if top_portal != null and top_portal.tilemap != null:
		top_portal.tilemap.set_cell(top_portal.tilemap_coordinates.x,
					top_portal.tilemap_coordinates.y, top_portal.overwritten_tile_index)
		top_portal.object_ref.queue_free()

func push_portal(portal):
	PortalQueue.push_back(portal)
	portal.tilemap.set_cellv(portal.tilemap_coordinates, TileMap.INVALID_CELL)

class PortalInstance:
	var type = PortalType.STANDARD
	var tilemap_coordinates = Vector2.ZERO
	var tilemap = null
	var overwritten_tile_index = -1
	var object_ref
	
	func _init(portal_type, coordinates, tm, obj):
		type = portal_type
		tilemap = tm
		tilemap_coordinates = coordinates
		overwritten_tile_index = tilemap.get_cell(tilemap_coordinates.x, tilemap_coordinates.y)
		object_ref = obj
