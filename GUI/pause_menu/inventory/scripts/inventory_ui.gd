class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/pause_menu/inventory/inventory_slot.tscn")

var focus_index: int = 0

@export var data : InventoryData

func _ready() -> void:
	PauseMenu.shown.connect(update_inventory)
	PauseMenu.hidden.connect(clear_inventory)
	clear_inventory()
	data.changed.connect(on_inventory_changed)
	pass


func clear_inventory() -> void:
	for node in get_children():
		node.queue_free()


func update_inventory(focused_index: int = 0) -> void:
	for slot in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = slot
		new_slot.focus_entered.connect(item_focused)
	
	#Mise à jour des eléments sélectionnés
	await get_tree().process_frame
	get_child(focused_index).grab_focus()


#A chaque changement sur l'inventaire, l'inventaire est purgé puis reconstruit
func on_inventory_changed() -> void:
	var index = focus_index
	clear_inventory()
	update_inventory(index)


func item_focused() -> void:
	for index in get_child_count():
		if get_child(index).has_focus():
			focus_index = index
			return
			
