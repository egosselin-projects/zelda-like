extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

	if PlayerManager.player_spawned == false:
		# Ici on réccupére la position du noeud pour spawn le joueur à son emplacement
		# sur la scéne parente 
		PlayerManager.set_player_position(global_position)
		PlayerManager.player_spawned = true
