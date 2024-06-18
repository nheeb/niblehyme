extends Node

var DEBUG_CONTROL_DRILL_WITH_ARROW_KEYS := true # turn this off later

signal drill_hit_object(holo_object: HoloObject)

const LAYER_SIZE = 10
var current_layer := 0
signal new_layer_reached(layer: int)

func advance_layer():
	current_layer += 1
	new_layer_reached.emit(current_layer)

var cockpit
var main_pipe : Pipe
