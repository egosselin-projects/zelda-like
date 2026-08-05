@tool
@icon("res://GUI/dialog_system/icons/question_bubble.svg")

class_name DialogChoice extends DialogItem

var dialog_branches: Array[DialogBranch]


func _ready() -> void:
	#if Engine.is_editor_hint():
	#	return

	super()
	# Ajout des branches à la collection
	for node in get_children():
		if node is DialogBranch:
			dialog_branches.append(node)


func _get_configuration_warnings() -> PackedStringArray:
	if not _check_for_dialog_branches():
		return ["Must have at least 2 DialogBranches nodes"]

	return []


func _check_for_dialog_branches() -> bool:
	var dialog_branch_nodes: int = 0	

	for node in get_children():
		if node is DialogBranch:
			dialog_branch_nodes += 1

	if dialog_branch_nodes >= 2:
		return true

	return false


func _set_editor_display() -> void:
	_set_related_text()
	if dialog_branches.size() < 2:
		return

	example_dialog.set_dialog_choice(self)


func _set_related_text() -> void:
	var _parent = get_parent()
	var _target = _parent.get_child(self.get_index() - 1)
	
	if _target is DialogText:
		example_dialog.set_dialog_text(_target)
		example_dialog.content.visible_characters = -1
