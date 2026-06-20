class_name Level extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Forçage du y_sort, et création du lien parent/enfant
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)


func _free_level() -> void:
	# Pour éviter de supprimer l'instance du joueur avec le niveau
	PlayerManager.unparent_player(self)
	queue_free()
