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
	views.append_array(view_root.get_children())
	view_count = len(views)

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
	var camera_pivot = get_parent().global_position
	var camera = %PlayerCamera
	var plane = Plane(%PlaneReference.global_position,.7)
	var mouse_position = plane.intersects_ray(camera_pivot,camera.project_ray_normal(get_viewport().get_mouse_position()))
	
	%RayCast3D.target_position = mouse_position
	var obj = %RayCast3D.get_collider()
	
	if (obj is PipeItem): Game.raycast_object = obj
	if (mouse_position != null): Game.mouse_position = mouse_position
#	print(mouse_position, obj)
