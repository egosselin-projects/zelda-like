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


# Rassemblement de l'inventaire dans un array
func get_save_data() -> Array:
	var item_save: Array = []

	for slot_index in slots.size():
		item_save.append(item_to_save(slots[slot_index]))
	
	return item_save

# Conversion des items d'inventaire en dictionnaire
func item_to_save(slot: SlotData) -> Dictionary:
	var result = { item = "", quantity = 0 }

	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
			
	return result


func parse_save_data(save_data: Array) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize(array_size)

	for slot_index in slots.size():
		slots[slot_index] = item_from_save(save_data[slot_index])
	connect_slots()


func item_from_save(save_object: Dictionary) -> SlotData:
	if save_object.item == "":
		return null

	var new_slot: SlotData = SlotData.new()
	new_slot.item_data = load(save_object.item)
	new_slot.quantity = int(save_object.quantity)
	return new_slot


func use_item(item: ItemData, count: int = 1) -> bool:
	for slot in slots:
		if slot:
			if slot.item_data == item and slot.quantity >= count:
				slot.quantity -= count
				return true
	
	return false
				
