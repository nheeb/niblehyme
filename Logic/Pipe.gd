extends Path3D
class_name Pipe

@onready var discard_path : Path3D = %DiscardPath
@onready var collect_path : Path3D = %CollectPath

var length : float
var active_secondary_path : Path3D

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
	
