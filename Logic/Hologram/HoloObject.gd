class_name HoloObject extends Node3D

var health: DrillingHealth

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
	## Connecting the Drilling Health
	if has_node("DrillingHealth"):
		health = get_node("DrillingHealth")
	else:
		health = DrillingHealth.new()
		add_child(health)
	health.chunk_drilled.connect(drill_chunk)
	health.completely_drilled.connect(destroy)

func is_touching_drill() -> bool:
	if has_node("HoloArea"):
		var area : HoloArea = get_node("HoloArea") as HoloArea
		if area:
			return not area.get_overlapping_areas().is_empty()
	return false

func drill_first_contact():
	_on_drill_first_contact()

func drill_damage(damage: float):
	health.drill_damage(damage)

func drill_chunk():
	_on_chunk_drilled()

func destroy():
	_on_destroyed()

#####################
## For overwriting ##
#####################
func _on_drill_first_contact():
	pass

func _on_chunk_drilled():
	pass

func _on_destroyed():
	pass

func _on_discovered():
	pass
