class_name HoloObject extends Node3D

var active := true
var holo_pos: Vector3

func update_visibility(visibility_progress: float):
	visible = visibility_progress >= .5
