class_name Device extends Node3D

func hover():
	pass

func mouse_down():
	pass

@export var cockpit_input_name: String
func update_cockpit_input(value):
	Game.cockpit.input.set(cockpit_input_name, value)
