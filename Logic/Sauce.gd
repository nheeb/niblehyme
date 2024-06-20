class_name Sauce extends Node

@export var drop_tables: Array[MineralDropTable]
@export var drop_tables_layers: Array[int]

@onready var health := $DrillingHealth

func drill(damage: float):
	health.drill_damage(damage)

func _on_drilling_health_chunk_drilled() -> void:
	var drop_table: MineralDropTable
	for i in range(drop_tables_layers.size() - 1, -1, -1):
		if Game.current_layer >= drop_tables_layers[i]:
			drop_table = drop_tables[i]
			break
	Game.main_pipe.add_to_mineral_queue(
		Mineral.create_mineral(drop_table.draw_random())
	)

func spawn_new_holo_objects(layer: int = 0) -> void:
	var object_count := randi_range(3,7)
	for i in range(object_count):
		spawn_random_holo_object(layer)

const HOLO_SPAWN_DISTANCE = 16.0
const HOLO_SPAWN_AREA_XZ = 20.0

const HOLO_OBSTACLE = preload("res://Logic/Hologram/HoloObstacle.tscn")
const HOLO_GOLD = preload("res://Logic/Hologram/HoloGoldOre.tscn")
func spawn_random_holo_object(layer: int = 0) -> void:
	var holo_object_pool : Array[PackedScene] = []
	if layer <= 10:
		holo_object_pool = [
			HOLO_OBSTACLE, HOLO_OBSTACLE, HOLO_OBSTACLE, HOLO_GOLD
		]
	else:
		holo_object_pool = [
			HOLO_OBSTACLE, HOLO_GOLD
		]
	var ho : HoloObject = holo_object_pool.pick_random().instantiate()
	ho.holo_pos = Game.holo_drill.holo_pos + Vector3(
					randf_range(-1, 1) * HOLO_SPAWN_AREA_XZ,
					randf_range(-1, 0) * Game.LAYER_SIZE - HOLO_SPAWN_DISTANCE,
					randf_range(-1, 1) * HOLO_SPAWN_AREA_XZ)
	Game.hologram.add_holo_object_as_child(ho)
