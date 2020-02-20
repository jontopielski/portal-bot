extends Camera2D

const HIDDEN_POS_Y = -13

var text_target_pos_y = HIDDEN_POS_Y
var is_displaying_text = false

func _ready():
	$NotificationText.rect_position.y = HIDDEN_POS_Y
	$NotificationText/Text.text = ""

func _process(delta):
#	print($NotificationText.rect_position.y)
#	print(text_target_pos_y)
	if !compare_floats($NotificationText.rect_position.y, text_target_pos_y):
		$NotificationText.rect_position.y = lerp($NotificationText.rect_position.y, text_target_pos_y, .1)
	elif !is_displaying_text:
		$NotificationText/Text.text = ""

func display_text_start(text):
	if is_displaying_text:
		return
	is_displaying_text = true
	text_target_pos_y = 0
	$NotificationText/Text.text = text
	$Timer.start()

func display_text_end():
	is_displaying_text = false
	text_target_pos_y = HIDDEN_POS_Y

func _on_Timer_timeout():
	display_text_end()

const FLOAT_EPSILON = 0.1

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon
