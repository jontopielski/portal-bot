extends Node

onready var actions = get_node('actions')
onready var reducers = get_node('reducers')
onready var store = get_node('store')

func _ready():
	store.create([
		{'name': 'game', 'instance': reducers}
	], [
		{'name': '_on_store_changed', 'instance': self}
	])
