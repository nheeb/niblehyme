class_name DeviceArea extends Area3D

var device: Device

func _ready() -> void:
	if get_parent() is Device:
		device = get_parent()
