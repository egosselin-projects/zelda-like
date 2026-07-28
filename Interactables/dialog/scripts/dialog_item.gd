@tool
@icon("res://GUI/dialog_system/icons/chat_bubble.svg")

class_name DialogItem extends Node

@export var npc_info: NPCResources


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	check_npc_data()


#func _get_configuration_warnings() -> PackedStringArray:
	#if npc_info == null:
		#return ["NPC resource is not set"]
	#else:
		#return []


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
