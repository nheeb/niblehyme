extends RigidBody3D
class_name  PipeItem

@export var duration : float = 5

func _ready():
	freeze = true
	var parent = get_parent()
	if (parent is Path3D):
		var new_path_follow = PathFollow3D.new()
		var process_frame = get_tree().process_frame
		await process_frame
		parent.add_child.call_deferred(new_path_follow)
		reparent(new_path_follow)
		self.position = Vector3.ZERO
		await process_frame

		var tween := get_tree().create_tween()
		tween.tween_property(new_path_follow,"progress_ratio",1,duration)

		await tween.finished
		drop_out()
	else:
		printerr("Node: ",name," must be a child of Path3D!")
		queue_free()


func drop_out() -> void:
	var parent = get_parent()
	reparent(Game.cockpit)

	if (parent is PathFollow3D):
		parent.queue_free()

	freeze = false


