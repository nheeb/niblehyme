class_name HoloObject extends Node3D

var active := true
var holo_pos: Vector3:
	set(x):
		holo_pos = x
		position = x

func update_visibility(visibility_progress: float):
	scale = visibility_progress * Vector3.ONE
	visible = visibility_progress >= .1

func _ready() -> void:
	holo_pos = position
	print(holo_pos)

func is_touching_drill() -> bool:
	if has_node("HoloArea"):
		var area : HoloArea = get_node("HoloArea") as HoloArea
		if area:
			return not area.get_overlapping_areas().is_empty()
	return false

func drill_first_contact():
	_on_drill_first_contact()

func drill_damage(drill_power: float):
	_on_drill_damage(drill_power)

#####################
## For overwriting ##
#####################
func _on_drill_first_contact():
	pass

func _on_drill_damage(drill_power: float):
	pass
