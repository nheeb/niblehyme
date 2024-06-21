extends Node
class_name Shop

var items : Array = []


func _ready():
	var children = get_children()
	items = children.filter(func(i): return i is ShopItem)


func close_shop():
	get_tree().change_scene_to_file("res://Logic/Cockpit.tscn")

func update_buttons() -> void:
	for i in items:
		i.check_buyable()
