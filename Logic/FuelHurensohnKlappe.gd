extends Node3D

var door_is_closed : bool :
	set(state):
		if (state):
			%APFuelDoor.play("Close")
		else:
			%APFuelDoor.play("Open")
		door_is_closed = state
var active_item : PipeItem

func _ready():
	door_is_closed = true

func _on_area_3d_body_entered(body):
	if (body is PipeItem): if (body.dragging): active_item = body

func _on_area_3d_body_exited(body):
	if (body is PipeItem): if (body.dragging): active_item = body



func _physics_process(_delta):

	if (door_is_closed): return
	if (active_item == null): return
	if (active_item.dragging): return
	
	yeet_into_oven(active_item)
	active_item = null
	

func yeet_into_oven(obj) -> void:
	if (obj is RigidBody3D):
		obj.apply_impulse(Vector3.BACK)
	
	var timer := get_tree().create_timer(.5)
	await timer.timeout
	obj.queue_free()


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if (event is InputEventMouse):
		if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
			door_is_closed = !door_is_closed
