@tool
@icon("res://GUI/dialog_system/icons/answer_bubble.svg")

class_name DialogBranch extends DialogItem

@export var text: String = "placeholder": set = _set_text

var dialog_items: Array[DialogItem]

func _ready() -> void:
	super()
	if Engine.is_editor_hint():
		return
	
	for child in get_children():
		if child is DialogItem:
			dialog_items.append(child)


func _set_text(value: String) -> void:
	text = value
	if Engine.is_editor_hint():
		if example_dialog != null:
			_set_editor_display()


func _set_editor_display() -> void:
	var _parent = get_parent()
	if _parent is DialogChoice:
		_set_related_text()
	
		if _parent.dialog_branches.size() < 2:
			return
		
		example_dialog.set_dialog_choice(_parent as DialogChoice)


func _set_related_text() -> void:
	var _parent = get_parent()
	var _parent2 = _parent.get_parent()
	var _target = _parent2.get_child(_parent.get_index() - 1)
	
	if _target is DialogText:
		example_dialog.set_dialog_text(_target)
		example_dialog.content.visible_characters = -1
