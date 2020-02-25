extends MarginContainer

enum MenuOption {
	START,
	OPTIONS,
	CREDITS
}

const BASE_COLOR = Color.white
const SELECTION_COLOR = Color.gray

var curr_menu_option = MenuOption.START

onready var start_label = $MenuItems/MenuOptions/StartContainer/Start
onready var options_label = $MenuItems/MenuOptions/OptionsContainer/Options
onready var credits_label = $MenuItems/MenuOptions/CreditsContainer/Credits

func _ready():
#	update_menu_ui()
	pass

func _process(delta):
	pass
#	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left"):
#		decrement_menu_selection()
#	elif Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right"):
#		increment_menu_selection()

func update_menu_ui():
	return
	update_label(start_label, MenuOption.START, "start")
	update_label(options_label, MenuOption.OPTIONS, "options")
	update_label(credits_label, MenuOption.CREDITS, "credits")

func update_label(label, menu_option, base_text):
	return
	if curr_menu_option == menu_option:
		label.text = "> %s" % base_text
		label.add_color_override("font_color", SELECTION_COLOR)
	else:
		label.text = base_text
		label.add_color_override("font_color", BASE_COLOR)

func increment_menu_selection():
	return
	if curr_menu_option == MenuOption.CREDITS:
		return
	else:
		curr_menu_option += 1
		update_menu_ui()

func decrement_menu_selection():
	return
	if curr_menu_option == MenuOption.START:
		return
	else:
		curr_menu_option -= 1
		update_menu_ui()
