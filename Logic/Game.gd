class_name GameInfo extends Node

@onready var sauce: Sauce = $Sauce

var DEBUG_CONTROL_DRILL_WITH_ARROW_KEYS := false # turn this off later

signal drill_hit_object(holo_object: HoloObject)

const LAYER_SIZE = 10
var current_layer := 0
signal new_layer_reached(layer: int)

func advance_layer():
	current_layer += 1
	new_layer_reached.emit(current_layer)

var cockpit : Cockpit
var main_pipe : Pipe
var raycast_object: Object:
	set(ro):
		if raycast_object != ro:
			raycast_object = ro
			if raycast_object:
				if raycast_object.has_method("hover"):
					raycast_object.call("hover")
var mouse_position
var camera: Camera3D
var mouse_normal: Vector3

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		if raycast_object:
			if raycast_object.has_method("mouse_down"):
				raycast_object.call("mouse_down")
