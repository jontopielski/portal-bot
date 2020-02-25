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

const SNAKECHARMER_SPEED = 3

const DEATH_TILES = [8, 54, 55, 56, 57, 65]

const TILE_SPIKE_INDEX = 8
const TILE_INACTIVE_SAVE_POINT_INDEX = 9
const TILE_REGULAR = 1
const TILE_ACTIVE_SAVE_POINT_INDEX = 10
const TILE_SIGN_INDEX = 12
const TILE_PRESSURE_PAD_ZERO = 90
const TILE_PRESSURE_PAD_ONE = 91
const TILE_FALLING_PLATFORM_1 = 81
const TILE_FALLING_PLATFORM_2 = 83

const BULLET_TILE_INDEX_BLACKLIST = [-1, 8, 9, 10, 12, 39, 40, 41, 42, 43, 49, 49, 50, \
		51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 105, 106, 107, 90, 91]

const PORTAL_CREATION_WHITELIST = PoolVector2Array([Vector2(29, 1)])

const SIGN_NO_JUMPING = "no jump program installed"
const SIGN_PRE_GUN = "branch out a little bit"
const SIGN_THIRD = "don't tire out yet"
const SIGN_FOURTH = "you're not trash"
const SIGN_FIVE = "i won't hole-d your hand"
const SIGN_YOU_ROCK = "u rock"
const SIGN_SPIKE_CEILING = "stop and stair"
const SIGN_SNAKE_SPIKE_AND_FALL = "snake pass"
const SIGN_UPSIDE_DOWN_TILES = "left out"
const SIGN_BRIDGE = "bridge the divide"
const SIGN_POST_DOUBLE_SNAKE = "there's always tomb-orrow"
const SIGN_FINAL = "hope that didn't tire u out too much"
