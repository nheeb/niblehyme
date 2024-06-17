extends Node

var DEBUG_CONTROL_DRILL_WITH_ARROW_KEYS := true

signal on_drill_hit_object(holo_object: HoloObject)

const LAYER_SIZE = 10
var current_layer := 0
signal on_new_layer_reached(depth: float)

var cockpit
var main_pipe : Pipe
