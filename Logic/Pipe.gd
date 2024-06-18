extends Path3D
class_name Pipe

@onready var discard_path : Path3D = %DiscardPath
@onready var collect_path : Path3D = %CollectPath

var length : float
var active_secondary_path : Path3D

const MINERAL_DELAY = .25
const MINERAL_DELAY_VARIANCE = .15
var mineral_queue : Array[Mineral]
var mineral_queue_cooldown := false

func _process(delta: float) -> void:
	if not mineral_queue_cooldown:
		if not mineral_queue.is_empty():
			mineral_queue_cooldown = true
			spawn_mineral(mineral_queue.pop_front())
			await get_tree().create_timer(\
				MINERAL_DELAY + randf() * MINERAL_DELAY_VARIANCE).timeout
			mineral_queue_cooldown = false

func add_to_mineral_queue(mineral: Mineral):
	mineral_queue.append(mineral)

func spawn_mineral(mineral: Mineral):
	pass

func _ready():
	Game.main_pipe = self
	length = curve.get_baked_length()
	%Switch.switch.connect(switch_pipe)

func switch_pipe(mode:String) -> void:
	var duration : float
	match(mode):
		"Collect": active_secondary_path = collect_path
		"Discard": active_secondary_path = discard_path

func should_item_be_collected(path:Path3D) -> bool:
	if (path == collect_path): return true
	return false
	
