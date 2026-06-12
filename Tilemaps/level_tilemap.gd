class_name LevelTileMap extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ajustement des limites de la caméra au terrain dessiné au chargement
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())


# Réccupération de la zone du terrain pour limiter les mouvements de la caméra
func get_tilemap_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	# Coordonnées du coin en haut a gauche
	bounds.append(
		Vector2(get_used_rect().position * rendering_quadrant_size),
	)
	# Coordonnées du coin en bas à droite
	bounds.append(
		Vector2(get_used_rect().end * rendering_quadrant_size),
	)
	
	return bounds
