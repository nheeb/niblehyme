class_name Cockpit extends Node3D

@onready var input: CockpitInput = $Input

func _ready():
	Game.cockpit = self
