@tool

class_name TreasureChest extends Node

@export var item_data: ItemData : set = _set_item_data
@export var quantity: int = 1 : set = _set_quantity 

var is_open: bool = false

@onready var item_sprite: Sprite2D = $ItemSprite
@onready var label: Label = $ItemSprite/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D


func _ready() -> void:
	_update_texture()
	_update_label()

	# Point de sortie du tool
	if Engine.is_editor_hint():
		return
	
	interact_area.area_entered.connect(_on_area_entered)
	interact_area.area_exited.connect(_on_area_exit)
	

func player_interact() -> void:
	print("PLAYER INTERACT CHEST")
	if is_open:
		return

	is_open = true
	animation_player.play("open_chest")

	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item(item_data, quantity)
	else:
		printerr("no items in chest")
		push_error("no items in chest, chest name : ", name)


func _on_area_entered(_area: Area2D) -> void:
	print("ENTER CHEST AREA")
	PlayerManager.interact_pressed.connect(player_interact)


func _on_area_exit(_area: Area2D) -> void:
	print("EXIT CHEST AREA")
	PlayerManager.interact_pressed.disconnect(player_interact)


func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()


func _set_quantity(value: int) -> void:
	quantity = value
	_update_label()


func _update_texture() -> void:
	if item_data and item_sprite:
		item_sprite.texture = item_data.texture


func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str(quantity)
