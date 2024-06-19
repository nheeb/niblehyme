extends Node3D

var current_mode : Mode
var opposite_mode : Mode
enum Mode {Collect,Discard}

signal switch

func _ready():
	switch_mode(Mode.Collect)

func switch_mode(mode:Mode=opposite_mode) -> void:
	match(mode):
		Mode.Collect:
			current_mode = Mode.Collect
			opposite_mode = Mode.Discard
			switch.emit("Collect")
		Mode.Discard:
			current_mode = Mode.Discard
			opposite_mode = Mode.Collect
			switch.emit("Discard")

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if (event is InputEventMouseButton and event.is_pressed()):
		if event.button_index == MOUSE_BUTTON_LEFT:
			switch_mode()
