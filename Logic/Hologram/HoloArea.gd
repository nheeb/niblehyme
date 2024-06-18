class_name HoloArea extends Area3D

@onready var object : HoloObject = get_parent()

func _on_area_entered(_area: Area3D) -> void:
	Game.drill_hit_object.emit(object)
	object.drill_first_contact()
