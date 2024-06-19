extends HoloObject

@export var follow_range := 5.0
@export var follow_object: HoloObject

func _process(delta: float) -> void:
	var dist := holo_pos.distance_to(follow_object.holo_pos)
	if dist >= follow_range:
		holo_pos += (dist - follow_range) * holo_pos.direction_to(follow_object.holo_pos)
