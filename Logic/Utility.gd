extends Node

func remove_y_value(pos: Vector3) -> Vector3:
	pos.y = 0.0
	return pos

func no_y_normalized(vec: Vector3) -> Vector3:
	return remove_y_value(vec).normalized()

func y_plane_dist(pos1: Vector3, pos2: Vector3) -> float:
	return remove_y_value(pos1).distance_to(remove_y_value(pos2))

func clamp_map(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float:
	value = clamp(value, istart, istop)
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))

func clamp_map_pow(value: float, istart: float, istop: float, ostart: float, ostop: float, e: float) -> float:
	var middle = pow(clamp_map(value, istart, istop, 0.0, 1.0), e)
	return lerp(ostart, ostop, middle)

func align_node(node: Node3D, local_direction: Vector3, target_global_direction: Vector3):
	var current_global_direction := node.global_position.direction_to(node.to_global(local_direction))
	var cross_direction := current_global_direction.cross(target_global_direction).normalized()
	if cross_direction.is_normalized():
		var rotation_angle := current_global_direction.signed_angle_to(target_global_direction, cross_direction)
		node.rotate(cross_direction, rotation_angle)

func recursive_set_light_layers(node: Node, layers: int):
	for c in node.get_children():
		recursive_set_light_layers(c, layers)
		if c is VisualInstance3D:
			(c as VisualInstance3D).layers = layers

func get_recursive_mesh_instances(node: Node) -> Array[MeshInstance3D]:
	var mesh_instances : Array[MeshInstance3D] = []
	for c in node.get_children():
		mesh_instances.append_array(get_recursive_mesh_instances(c))
		if c is MeshInstance3D:
			mesh_instances.append(c)
	return mesh_instances

# ----- Hex functions -----
func cube_add(r1: int, q1: int, s1: int, r2: int, q2: int, s2: int) -> Vector3i:
	return Vector3i(r1 + r2, q1 + q2, s1 + s2)
	
func axial_add():
	pass

func random_index_of_scores(scores: Array[float]) -> int:
	if scores.is_empty():
		printerr("Random index: Empty list")
		return -1
	var total_size : float = scores.reduce(func(a,b): return a + b, 0.0)
	if total_size == 0.0:
		printerr("Random index: Only Zero entries")
		return -1
	var random_value := randf_range(0.0, total_size)
	for i in range(scores.size()):
		random_value -= scores[i]
		if random_value < 0.0:
			return i
	printerr("Random index: Something went wrong")
	return -1

## the hit chance should be between 0 and 100
func random_hit(hit_chance: float) -> bool:
	assert(hit_chance >= 0.0 and hit_chance <= 100.0)
	return randf() <= (hit_chance * 0.01)

## could maybe be put in Utils singleton
func rq_distance(r1: int, q1: int, r2: int, q2: int) -> int:
	return (abs(q1 - q2) 
			+ abs(q1 + r1 - q2 - r2)
			+ abs(r1 - r2)) / 2

func array_unique(array: Array) -> Array:
	var unique: Array = []
	for item in array:
		if not unique.has(item):
			unique.append(item)
	return unique

func random_hash(length:int, chars := "abcdefghijklmnopqrstuvwxyz") -> String:
	var word: String = ""
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

func has_int_flag(flags: int, target_flag: int) -> bool:
	return (flags & target_flag) == target_flag

func add_int_flag(flags: int, target_flag: int) -> int:
	return flags | target_flag

func remove_int_flag(flags: int, target_flag: int) -> int:
	return flags & (~target_flag)

func take_screenshot(shrink_count := 0) -> ImageTexture:
	var image := Game.get_viewport().get_texture().get_image()
	for i in range(shrink_count):
		image.shrink_x2()
	#image.compress(Image.COMPRESS_ASTC)
	var texture := ImageTexture.create_from_image(image)
	return texture

func get_mouse_pos_absolute() -> Vector2:
	return get_viewport().get_mouse_position()

## for when the viewport resolution doesn't match the content_scale	
func scale_screen_pos(screen_pos: Vector2) -> Vector2:
	
	var current_viewport_size: Vector2 = get_tree().root.size
	var reference_viewport_size: Vector2 = get_tree().root.content_scale_size
	var viewport_scale: Vector2 = current_viewport_size / reference_viewport_size
	var size_scale: float = minf(viewport_scale.x, viewport_scale.y)
	#var scaled: Vector2 = Vector2(viewport_scale.x * screen_pos.x, viewport_scale.y * screen_pos.y)
	var scaled: Vector2 = screen_pos * size_scale
	return scaled

## for when the viewport resolution doesn't match the content_scale		
func inv_scale_screen_pos(screen_pos: Vector2) -> Vector2:
	var current_viewport_size: Vector2 = get_tree().root.size
	var reference_viewport_size: Vector2 = get_tree().root.content_scale_size
	var viewport_scale: Vector2 = reference_viewport_size / current_viewport_size
	var size_scale: float = minf(viewport_scale.x, viewport_scale.y)
	#var scaled: Vector2 = Vector2(viewport_scale.x * screen_pos.x, viewport_scale.y * screen_pos.y)
	var scaled: Vector2 = size_scale * screen_pos
	return scaled

func get_mouse_pos_normalized(invert_y_axis := true) -> Vector2:
	var absolute := get_mouse_pos_absolute()
	if invert_y_axis:
		return Vector2(absolute.x / get_viewport().get_visible_rect().size.x, 1.0 - (absolute.y / get_viewport().get_visible_rect().size.y))
	else:
		return Vector2(absolute.x / get_viewport().get_visible_rect().size.x, absolute.y / get_viewport().get_visible_rect().size.y)

func vec_xy_to_vec3(v: Vector2, z := 0.0) -> Vector3:
	return Vector3(v.x, v.y, z)

func vec3_discard_z(v: Vector3) -> Vector2:
	return Vector2(v.x, v.y)

func array_safe_get(array: Array, index: int, mirror := false, default = null) -> Variant:
	if mirror:
		while not index < len(array):
			index -= len(array)
		while not index >= -len(array):
			index += len(array)
	if index >= -len(array) and index < len(array):
		return array[index]
	else:
		return default

func get_parent_of_type(n: Node, type) -> Node:
	var parent: Node = n.get_parent()
	while parent:
		if is_instance_of(parent, type):
			return parent
		parent = parent.get_parent()
	printerr("No parent of %s with type %s found." % [n, type])
	return null

func array_sum(array: Array):
	return array.reduce(func(a,b): return a+b)

func array_average(array: Array):
	return array_sum(array) * (1.0 / array.size())

func random_direction() -> Vector3:
	return Vector3.UP.rotated(Vector3.FORWARD, TAU * randf())\
					 .rotated(Vector3.UP, TAU * randf())

func positive_angle(radians: float) -> float:
	return fposmod(radians, TAU)

func quadratic_bezier_3D(p0: Vector3, p1: Vector3, p2: Vector3, t: float) -> Vector3:
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r
