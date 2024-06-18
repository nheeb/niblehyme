class_name Sauce extends Node

@onready var health := $DrillingHealth

func drill(damage: float):
	health.drill_damage(damage)

func _on_drilling_health_chunk_drilled() -> void:
	pass # Replace with function body.
