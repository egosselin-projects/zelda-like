class_name InventoryData extends Resource

@export var slots: Array[SlotData]


func _init() -> void:
	connect_slots()
	

func add_item(item : ItemData, count: int = 1) -> bool:
	for slot in slots:
		if slot:
			# Si item déjà présent, maj de la quantité
			if slot.item_data == item:
				slot.quantity += count
				return true
	
	for slot_index in slots.size():
		if slots[slot_index] == null:
			var new_slot = SlotData.new()
			new_slot.item_data = item
			new_slot.quantity = count
			slots[slot_index] = new_slot
			new_slot.changed.connect(_on_slot_changed)
			return true

	print("inventory full!")	
	return false


func connect_slots() -> void:
	for slot in slots:
		if slot:
			slot.changed.connect(_on_slot_changed)
			 

func _on_slot_changed() -> void:
	for slot in slots:
		if slot:
			if slot.quantity < 1:
				slot.changed.disconnect(_on_slot_changed)
				var index = slots.find(slot)
				slots[index] = null
				emit_changed()
	pass
	
	
	
