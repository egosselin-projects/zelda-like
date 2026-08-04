@tool
@icon("res://GUI/dialog_system/icons/question_bubble.svg")

class_name DialogChoice extends DialogItem

var dialog_branches: Array[DialogBranch]


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
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
