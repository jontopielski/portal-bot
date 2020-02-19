extends Node

const DEBUG_MODE = true
const BACKGROUND_COLOR = Color("29adff")

const GRAVITY = 100
const PLAYER_START_POSITION = Vector2(44, 52)
const PLAYER_TERMINAL_VELOCITY = 100
const PLAYER_WALK_SPEED = 45
const PLAYER_WALK_ACCELERATION = 10
const PLAYER_WALK_DECELERATION = 15
const PLAYER_FALL_ACCELERATION = 5
const PLAYER_FALL_DECELERATION = 5

const TILE_SPIKE_INDEX = 8
const DEATH_TILES = [8, 54, 55, 56, 57, 65]
const TILE_INACTIVE_SAVE_POINT_INDEX = 9
const TILE_ACTIVE_SAVE_POINT_INDEX = 10
const TILE_SIGN_INDEX = 12

const BULLET_TILE_INDEX_BLACKLIST = [-1, 8, 9, 10, 12, 39, 40, 41, 42, 43, 49, 49, 50, \
		51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64]

const SIGN_NO_JUMPING = "no jump program installed"
const SIGN_PRE_GUN = "branch out a little bit"
const SIGN_THIRD = "don't tire out yet"
const SIGN_FOURTH = "you're not trash"
const SIGN_FIVE = "end of demo"
