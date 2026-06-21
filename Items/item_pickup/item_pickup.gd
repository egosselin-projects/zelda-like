@tool

class_name ItemPickup extends Node2D

@export var item_data: ItemData: set = _set_item_data

@onready var area_2d: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return

	area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if item_data:
			if PlayerManager.INVENTORY_DATA.add_item(item_data) == true:
				item_picked_up()


func item_picked_up() -> void:
	# Déconnexion du signal de collision (pour éviter un double ramassage d'objet)
	area_2d.body_entered.disconnect(_on_body_entered)
	audio_stream_player_2d.play()
	visible = false

	# On attends que l'effet sonore soit terminé avant de supprimer l'objet
	await audio_stream_player_2d.finished
	queue_free()
	pass


func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()
	pass


func _update_texture() -> void:
	if item_data and sprite:
		sprite.texture = item_data.texture
