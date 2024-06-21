extends Node
class_name ShopItem

@export var icon : Texture2D
@export var item_name : String
@export var price : int 

@export var bought : bool = false

func _ready(): 
	check_buyable()
	%RichTextLabel.text = "[center]"+ item_name + "[/center]"
	
	if !(get_parent() is Shop): printerr("Warning: ",item_name, " (",name,")", " is not a child of shop!")


func check_buyable() -> void:
	if (bought): 
		%Button.disabled = true
		%RichTextLabel.text = "[center][color=#808080][s]" + item_name + "[/s][/color][/center]"
		return
	%Button.disabled = !(price <= Game.gold)
	

func _on_button_pressed():
	Game.gold -= price
	bought = true
	if (get_parent() is Shop):
		get_parent().update_buttons()
	else:
		printerr("Warning: ",item_name, " (",name,")", " is not a child of shop!")

