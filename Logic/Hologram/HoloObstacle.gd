extends HoloObject

func _on_drill_first_contact():
	Game.camera_path.screen_shake()
