extends Node3D

var holo_object: HoloObject

func _ready() -> void:
	if get_parent() is HoloObject:
		holo_object = get_parent()

func _process(delta: float) -> void:
	%Label3D.text = "%.2f m" % holo_object.holo_pos.distance_to(Game.holo_drill.holo_pos)
