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
