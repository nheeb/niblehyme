extends HoloObject

const MAX_TURN_ANGLE = .38 * PI

## Actual direction of the drill
var drill_direction: Vector3

## The input of the two sliders (values going from -1 to 1)
var target_turn_2d: Vector2
var current_turn_2d: Vector2
const TURN_VELOCITY = .8

## The input of the movement drive slider (0.0 - 1.0)
var movement_power := 0.0
const MOVEMENT_VELOCITY_MAX = 2.5

func _ready() -> void:
	super._ready()
	Game.holo_drill = self

func _process(delta: float) -> void:
	update_rotation(delta)
	update_position(delta)
	drilling_process(delta)

func update_rotation(delta: float) -> void:
	if Game.DEBUG_CONTROL_DRILL_WITH_ARROW_KEYS:
		target_turn_2d.y = Input.get_axis("ui_down", "ui_up")
		target_turn_2d.x = Input.get_axis("ui_right", "ui_left")
		if target_turn_2d.length_squared() > 1.0:
			target_turn_2d = target_turn_2d.normalized()
	else:
		target_turn_2d = Vector2(Game.cockpit.input.navigation_x, Game.cockpit.input.navigation_z)
	
	current_turn_2d = current_turn_2d.move_toward(target_turn_2d, delta * TURN_VELOCITY)
	var angle = current_turn_2d.angle()
	var dist = min(1.0, current_turn_2d.length())
	var turn = dist * MAX_TURN_ANGLE
	
	%Model.rotation.z = -turn
	%Model.rotation.y = -angle
	
	drill_direction = -%Model.transform.basis.y

func update_position(delta: float) -> void:
	if Game.DEBUG_CONTROL_DRILL_WITH_ARROW_KEYS:
		if Input.is_action_just_pressed("ui_page_up") or Input.is_action_just_pressed("ui_page_down"):
			movement_power += .2 * Input.get_axis("ui_page_down", "ui_page_up")
			movement_power = clamp(movement_power, 0.0, 1.0)
	else:
		movement_power = Game.cockpit.input.navigation_drive
			
	holo_pos += drill_direction * delta * MOVEMENT_VELOCITY_MAX * movement_power

	if -holo_pos.y > (1 + Game.current_layer) * Game.LAYER_SIZE:
		Game.advance_layer()

func drilling_process(delta: float):
	for ho in get_colliding_holo_objects():
		ho.drill_damage(delta * DrillStats.efficiency)
	Game.sauce.drill(delta * DrillStats.efficiency * movement_power)

func get_colliding_holo_objects() -> Array[HoloObject]:
	var holo_objects : Array[HoloObject] = []
	for area in %DrillArea.get_overlapping_areas():
		if area is HoloArea:
			holo_objects.append(area.object)
	return holo_objects
