extends RigidBody3D
class_name  PipeItem

var duration : float = 5

func _ready():
	freeze = true
	
	var parent = get_parent()
	if (parent is Path3D):
		flow_through_pipe()
	else:
		printerr("Node: ",name," must be a child of Path3D!")
		queue_free()


func flow_through_pipe() -> void:
	duration = DrillStats.pipe_flow_duration
	
	var new_path_follow = PathFollow3D.new()
	var process_frame = get_tree().process_frame
	await process_frame
	get_parent().add_child.call_deferred(new_path_follow)
	reparent(new_path_follow)
	self.position = Vector3.ZERO
	await process_frame

	var tween := get_tree().create_tween()
	tween.tween_property(new_path_follow,"progress_ratio",1,duration)

	await tween.finished
	
	var main_pipe = Game.main_pipe
	if (main_pipe == null): return
	var secondary_path : Path3D = Game.main_pipe.active_secondary_path
	
	var speed : float = main_pipe.length / duration 
	var secondary_path_duration : float = secondary_path.curve.get_baked_length() * speed
	
	if (get_parent() is PathFollow3D):
		get_parent().progress_ratio = 0
		get_parent().reparent(secondary_path)
		
		await get_tree().process_frame
		var new_tween = get_tree().create_tween()
		new_tween.tween_property(get_parent(),"progress_ratio",1,secondary_path_duration)
		await new_tween.finished
	
	
	if (main_pipe.should_item_be_collected(secondary_path)):
		drop_out()
	else:
		if (get_parent() is PathFollow3D):
			get_parent().queue_free()
		queue_free()

func drop_out() -> void:
	var parent = get_parent()
	reparent(Game.cockpit)

	if (parent is PathFollow3D):
		parent.queue_free()

	freeze = false

var dragging : bool = false

func _unhandled_input(event):
	if (freeze): return
	if (Game.raycast_object != self): return

	if (event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT)):
		if (event.is_pressed()):
			dragging = true
		if (event.is_released()):
			dragging = false


func _process(_delta):
	if (dragging):
		global_position = global_position.lerp(Game.mouse_position, .2)
