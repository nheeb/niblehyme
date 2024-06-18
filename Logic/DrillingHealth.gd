class_name DrillingHealth extends Node

@export var active := true
@export var limited_chunks := true
@export var chunk_count := 3
@export var chunk_count_variance := 2
@export var chunk_health := 1.0
@export var chunk_health_variance := .5

var current_health := 0.0
var current_chunk_count := 0

signal chunk_drilled
signal completely_drilled

func _init() -> void:
	if limited_chunks:
		current_chunk_count = chunk_count + randi_range(0, chunk_count_variance)
	current_health = chunk_health + randf() * chunk_health_variance

func drill_damage(damage: float):
	if active:
		current_health -= damage
		if current_health <= 0.0:
			chunk_drilled.emit()
			current_health = chunk_health + randf() * chunk_health_variance
			if limited_chunks:
				current_chunk_count -= 1
				if current_chunk_count <= 0:
					active = false
					completely_drilled.emit()
