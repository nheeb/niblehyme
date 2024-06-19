extends Node3D

@onready var pivot : Node3D = $CamPivot
@onready var view_root : Node3D = $Views
var views: Array[Camera3D] = []
var view_count : int

var current_view := 1
var selected_view := 1

var transitioning := false
const TRANSITION_DURATION = .34
var transition_direction: int
var transition_tween: Tween

func _ready() -> void:
	Game.camera = %PlayerCamera
	views.append_array(view_root.get_children())
	view_count = len(views)
	pivot.global_transform = views[current_view].global_transform

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("view_up"):
		selected_view = clamp(selected_view + 1, 0, view_count - 1)
	if Input.is_action_just_pressed("view_down"):
		selected_view = clamp(selected_view - 1, 0, view_count - 1)
	
	if not transitioning:
		if current_view != selected_view:
			transitioning = true
			transition_direction = sign(selected_view - current_view)
			current_view += transition_direction
			var transition_view := views[current_view]
			transition_tween = get_tree().create_tween()
			transition_tween.tween_property(pivot, "global_transform",\
				transition_view.global_transform, TRANSITION_DURATION)\
				.set_ease(Tween.EASE_IN_OUT)\
				.set_trans(Tween.TRANS_QUAD)
			await transition_tween.finished
			transitioning = false
	else:
		if transition_direction == - sign(selected_view - current_view):
			transition_tween.stop()
			transitioning = false
	
	check_mouse_colliding()


func check_mouse_colliding() -> void:
	var camera = %PlayerCamera
	Game.mouse_normal = camera.project_ray_normal(get_viewport().get_mouse_position())
	var camera_pivot = %CamPivot.global_position
	var plane = Plane(Vector3.FORWARD,.7)
	var mouse_position = plane.intersects_ray(
		camera_pivot, Game.mouse_normal
		)

	%RayCast3D.target_position = %RayCast3D.to_local(mouse_position) * 5.0
	var obj = %RayCast3D.get_collider()
	
	if (obj is PipeItem):
		Game.raycast_object = obj
	elif (obj is DeviceArea):
		Game.raycast_object = obj.device
	elif obj == null:
		Game.raycast_object = null
	else:
		printerr("Unknown collider: %s" % obj)
	if (mouse_position != null): Game.mouse_position = mouse_position

