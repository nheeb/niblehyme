extends Node

var char_duration : float = 0.05
var active_conversation : Conversation

signal next_snippet

var dialogue_queue : Array[Conversation]

func start_conversation(conv:Conversation,queue:bool=true) -> void:
	%UI.visible = true
	if (active_conversation != null):
		if (queue): dialogue_queue.append(conv)
		return

	active_conversation = conv
	build_conversation(conv)

func build_conversation(conversation:Conversation) -> void:
	for d in conversation.dialogue_snippets:
		show_icon(d)
		show_text(d)
		await next_snippet

	dialogue_queue.erase(active_conversation)
	active_conversation = null
	%RichTextLabel.text = ""
	%UI.visible = false


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
	if (active_conversation == null): 
		if (!dialogue_queue.is_empty()):
			var next_dialogue = dialogue_queue.pop_front()
			start_conversation(next_dialogue)
		return
	if (Input.is_action_just_pressed("next_line")):
		next_snippet.emit()
