extends Node3D

var holo_object: HoloObject

var global_y: float = 0.0

func _ready() -> void:
	if get_parent() is HoloObject:
		holo_object = get_parent()
	await get_tree().process_frame
	global_y = Game.hologram.socket_y.global_position.y

func _process(delta: float) -> void:
	if holo_object:
		if holo_object.visibility > .1:
			visible = true
			global_position.y = global_y
			%SocketPole.scale.y = to_local(holo_object.global_position).y

