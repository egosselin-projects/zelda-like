
class_name ItemMagnet extends Area2D

var items: Array[ItemPickup] = []
var speeds: Array[float] = []

@export var magnet_strength: float = 1.0
@export var play_magnet_audio: bool = false

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	for item_index in range(items.size() -1, -1, -1):
		var _item = items[item_index]
		
		if _item == null:
			# Quand l'item est réccupéré par le joueur est détruit, on purge la réf des tableaux
			items.remove_at(item_index)
			speeds.remove_at(item_index)
		elif _item.global_position.distance_to(global_position) > speeds[item_index]:
			# Tant que la distance avec le centre de l'objet collecteur > distance calculée
			# l'item continue a se déplacer vers le centre de l'objet collecteur
			speeds[item_index] += magnet_strength * delta
			_item.position += _item.global_position.direction_to(global_position) * speeds[item_index]
		else:
			# Dans ce cas l'item sera bloqué sur la postion du boomerang
			_item.global_position = global_position

# Ajout des items à la porté du joueur dans un tableau d'item
func _on_area_entered(_area: Area2D) -> void:
	if _area.get_parent() is ItemPickup:
		var _new_item := _area.get_parent() as ItemPickup
		items.append(_new_item)
		speeds.append(magnet_strength)
		# Désactivation de la gestion de la physique de l'objet ItemPickup
		# pour retirer la gestion des colisions
		_new_item.set_physics_process(false)
		
		if play_magnet_audio:
			audio.play(0)
