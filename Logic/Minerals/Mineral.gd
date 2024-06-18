class_name Mineral extends PipeItem

enum Type {Stone, Coal, Gold, Silver}

const PACKED_SCENES = {
	Type.Stone: preload("res://Logic/Minerals/MineralStone.tscn"),
	Type.Coal: preload("res://Logic/Minerals/MineralCoal.tscn"),
	Type.Gold: preload("res://Logic/Minerals/MineralGold.tscn"),
	Type.Silver: preload("res://Logic/Minerals/MineralSilver.tscn"),
}

static func create_mineral(type: Type) -> Mineral:
	var packed_scene : PackedScene = PACKED_SCENES[type]
	var mineral: Mineral = packed_scene.instantiate()
	mineral.hide()
	return mineral
