extends Node

var char_duration : float = 0.05

@export var list : Array[Conversation]
var active_conversation : Conversation

signal next_snippet

func _ready():
	
	start_conversation()

func start_conversation() -> void:
	active_conversation = list[0]
	build_conversation(active_conversation)

func build_conversation(conversation:Conversation) -> void:
	for d in conversation.dialogue_snippets:
		show_icon(d)
		show_text(d)
		await next_snippet

func show_icon(snippet:DialogueSnippet) -> void: 
	if (snippet.side == "LEFT"):
		pass
	else:
		pass

func show_text(snippet:DialogueSnippet) -> void:
	var displayed_text : String = snippet.interlocutor.name + ": " + snippet.text
	var duration : float = displayed_text.length() * char_duration
	%RichTextLabel.visible_ratio = 0
	%RichTextLabel.text = displayed_text
	
	var tween := get_tree().create_tween()
	tween.tween_property(%RichTextLabel,"visible_ratio",1,duration)

func _physics_process(_delta):
	if (active_conversation == null): return
	if (Input.is_action_just_pressed("next_line")):
		next_snippet.emit()
