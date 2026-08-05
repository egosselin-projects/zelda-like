@tool
@icon("res://GUI/dialog_system/icons/chat_bubble.svg")

class_name DialogItem extends Node

@export var npc_info: NPCResources

var editor_selection: EditorSelection
var example_dialog: DialogSystemNode


func _ready() -> void:
	if Engine.is_editor_hint():
		editor_selection = EditorInterface.get_selection()
		editor_selection.selection_changed.connect(_on_selection_changed)
		return
	
	check_npc_data()


func _on_selection_changed() -> void:
	if editor_selection == null:
		return

	# Purge des éléments instanciés précédement
	if example_dialog != null:
		example_dialog.queue_free()

	var selection = editor_selection.get_selected_nodes()
	
	if not selection.is_empty():
		if self == selection[0]:
			example_dialog = load("res://GUI/dialog_system/dialog_system.tscn").instantiate() as DialogSystemNode
			
			if example_dialog == null:
				return
			
			self.add_child(example_dialog)
			example_dialog.offset = get_parent_global_position() + Vector2(32, -200)
			check_npc_data()
			_set_editor_display()

	pass


func check_npc_data() -> void:
	if npc_info == null:
		var npc = self
		var _checking: bool = true
	
		while _checking:
			npc = npc.get_parent()
			
			if npc is NPC and npc.npc_resource:
				npc_info = npc.npc_resource
				_checking = false
			else:
				_checking = false


func get_parent_global_position() -> Vector2:
	var parent = self
	var _checking: bool = true

	while _checking == true:
		parent = parent.get_parent()
		if parent:
			if parent is Node2D:
				return parent.global_position
			else:
				_checking = false
	
	return Vector2.ZERO


func _set_editor_display() -> void:
	pass
