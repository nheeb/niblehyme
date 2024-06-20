extends Device

@export var min_value := 0.0
@export var max_value := 1.0
@export var start_progress := 0.0

var progress: float
var value: float

var dragging := false
var drag_start_pos : Vector3
var drag_start_progress : float

var drag_plane : Plane
var drag_direction : Vector3
var drag_length : float

func mouse_down():
	dragging = true
	drag_start_pos = get_mouse_pos()
	drag_start_progress = progress

func _process(delta: float) -> void:
	if dragging:
		if Input.is_action_just_released("select"):
			dragging = false
			return
		var drag : Vector3 = get_mouse_pos() - drag_start_pos
		var drag_projected = drag.project(drag_direction)
		var drag_sign : float = sign(drag_projected.dot(drag_direction))
		var change : float = drag_sign * drag_projected.length() / drag_length
		set_progress(drag_start_progress + change)

func _ready() -> void:
	drag_plane = Plane(
		%MarkerZero.global_position.direction_to(%MarkerPlaneNormal.global_position),
		%MarkerZero.global_position )
	drag_direction = %MarkerZero.global_position.direction_to(%MarkerOne.global_position)
	drag_length = %MarkerZero.global_position.distance_to(%MarkerOne.global_position)
	await get_tree().process_frame
	set_progress(start_progress)

func get_mouse_pos() -> Vector3:
	var pos = drag_plane.intersects_ray(Game.camera.global_position, Game.mouse_normal)
	if pos:
		return pos
	elif drag_start_pos:
		return drag_start_pos
	else:
		return Vector3.ZERO

func set_progress(p: float):
	p = clamp(p, 0.0, 1.0)
	progress = p
	%SliderHead.global_position = lerp(%MarkerZero.global_position,
										%MarkerOne.global_position, p)
	value = lerp(min_value, max_value, p)
	update_cockpit_input(value)
