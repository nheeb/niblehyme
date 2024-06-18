class_name MineralDropTable extends Resource

@export var pot: Array[Mineral.Type]
@export var reset_after_drawing := true

func draw_random(with_putting_back := reset_after_drawing) -> Mineral.Type:
	var type : Mineral.Type = pot.pick_random()
	if not with_putting_back:
		pot.erase(type)
	return type
