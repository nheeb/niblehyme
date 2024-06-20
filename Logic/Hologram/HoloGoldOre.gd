extends HoloObject

func _on_chunk_drilled():
	Game.main_pipe.add_to_mineral_queue(Mineral.create_mineral(Mineral.Type.Gold))
