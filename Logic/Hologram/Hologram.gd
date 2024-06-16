extends Node3D

const HOLO_VIEW_RANGE = 27.0
const HOLO_VIEW_FADE = 6.0

var center_object: HoloObject

func get_all_holo_objects() -> Array[HoloObject]:
	return %DrillCenterPivot.get_children().filter(func(x): return x is HoloObject)

func add_holo_object_as_child(ho: HoloObject):
	%DrillCenterPivot.add_child(ho)
	ho.position = ho.holo_pos

func _process(delta: float) -> void:
	if center_object:
		%DrillCenterPivot.position = -center_object.holo_pos
	for c in get_all_holo_objects():
		if c.active:
			if center_object:
				var dist := center_object.holo_pos.distance_to(c.holo_pos)
				c.update_visibility(smoothstep(HOLO_VIEW_RANGE, \
								HOLO_VIEW_RANGE + HOLO_VIEW_FADE, dist))
