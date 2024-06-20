extends Node


func _on_ui_visibility_changed():
	if (%UI.visible):
		get_tree().paused = true
		%PauseMenuUI.visible = true
		%SettingsUI.visible = false
	else:
		get_tree().paused = false


func _on_pause_menu_ui_visibility_changed():
	if (!%PauseMenuUI.visible and %UI.visible):
		%SettingsUI.visible = true

func _on_settings_ui_visibility_changed():
	if (!%SettingsUI.visible and %UI.visible):
		%PauseMenuUI.visible = true


func _on_bt_resume_pressed():
	%UI.visible = false


func _ready():
	%UI.visible = false

func _physics_process(delta):
	if (Input.is_action_just_pressed("settings")):
		%UI.visible = !%UI.visible
