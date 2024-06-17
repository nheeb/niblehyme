extends Node3D

const HOLO_VIEW_RANGE = 14.0
const HOLO_VIEW_FADE = 2.0
const HOLO_KEEP_RANGE = 30.0

var center_object: HoloObject

func get_all_holo_objects() -> Array[HoloObject]:
	var list : Array[HoloObject] = []
	list.append_array(%DrillCenterPivot.get_children().filter(func(x): return x is HoloObject))
	return list

func add_holo_object_as_child(ho: HoloObject):
	%DrillCenterPivot.add_child(ho)
	ho.position = ho.holo_pos

func _ready() -> void:
	center_object = $DrillCenterPivot/HoloDrill

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
	for c in get_all_holo_objects():
		if c.active:
			if center_object:
				var dist := center_object.holo_pos.distance_to(c.holo_pos)
				c.update_visibility(1.0 - smoothstep(HOLO_VIEW_RANGE, \
								HOLO_VIEW_RANGE + HOLO_VIEW_FADE, dist))
