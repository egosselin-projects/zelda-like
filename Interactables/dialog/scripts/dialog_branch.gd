@tool
@icon("res://GUI/dialog_system/icons/answer_bubble.svg")

class_name DialogBranch extends DialogItem

@export var text: String = "placeholder"

var dialog_items: Array[DialogItem]

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for child in get_children():
		if child is DialogItem:
			dialog_items.append(child)
