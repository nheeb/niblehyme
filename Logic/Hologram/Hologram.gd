class_name Hologram extends Node3D

const HOLO_VIEW_RANGE = 10.0
const HOLO_VIEW_FADE = 1.0
const HOLO_KEEP_RANGE = 30.0

@export var center_object: HoloObject

func get_all_holo_objects() -> Array[HoloObject]:
	var list : Array[HoloObject] = []
	list.append_array(%DrillCenterPivot.get_children().filter(func(x): return x is HoloObject))
	return list

func add_holo_object_as_child(ho: HoloObject):
	%DrillCenterPivot.add_child(ho)
	ho.position = ho.holo_pos

func _ready() -> void:
	Game.hologram = self

func _rare_process() -> void:
	## Delete far objects
	if center_object:
		for ho in get_all_holo_objects():
			if ho.holo_pos.distance_to(center_object.holo_pos) > HOLO_KEEP_RANGE:
				ho.queue_free()

func _process(delta: float) -> void:
	## Center holo view on drill
	if center_object:
		%DrillCenterPivot.position = -center_object.holo_pos * %DrillCenterPivot.scale.x
	## Update Object Visibilty
	if center_object:
		var center_pos := center_object.holo_pos
		for c in get_all_holo_objects():
			if c.active:
				var diff := c.holo_pos - center_pos
				var xz_dist = max(abs(diff.x), abs(diff.z))
				var xz_vis = 1.0 - smoothstep(HOLO_VIEW_RANGE, \
								HOLO_VIEW_RANGE + HOLO_VIEW_FADE, xz_dist)
				var y_vis = 1.0 - smoothstep(2.0, 3.0, diff.y)
				c.update_visibility(min(xz_vis, y_vis))
				#var dist := center_object.holo_pos.distance_to(c.holo_pos)
				#
				#c.update_visibility(1.0 - smoothstep(HOLO_VIEW_RANGE, \
								#HOLO_VIEW_RANGE + HOLO_VIEW_FADE, dist))
