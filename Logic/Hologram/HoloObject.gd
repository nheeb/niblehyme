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
	## Updating holo pos
	holo_pos = position
	## Applying material
	set_holo_material()
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

const HOLO_MATERIAL = preload("res://Logic/Hologram/HoloMaterial.tres")
@export var holo_color := Color.GREEN
func set_holo_material():
	var mat = HOLO_MATERIAL.duplicate()
	for mi in Utility.get_recursive_mesh_instances(self):
		mi.material_override = mat
		mi.material_override.set("shader_parameter/albedo", holo_color)

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
