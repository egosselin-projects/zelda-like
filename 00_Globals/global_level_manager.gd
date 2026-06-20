extends Node


var current_tilemap_bounds: Array[Vector2]
var target_transition: String
var position_offset: Vector2

signal tilemap_bound_changed(bounds: Array[Vector2])
signal level_load_started
signal level_loaded


func _ready() -> void:
	# Trigger du signal de fin de chargement de niveau
	await get_tree().process_frame
	level_loaded.emit()


func change_tilemap_bounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	tilemap_bound_changed.emit(bounds)


# Chargement d'un niveau
# level_path : le chemin Godot vers le niveau
# _target_transition : le nom de l'objet LevelTransition cible sur le niveau a charger
# _position_offset : L'offset en rapport à l'objet LevelTransition cible
func load_new_level(level_path: String, _target_transition: String, _position_offset: Vector2) -> void:
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	print("position_offset ", position_offset, " target_transition ", target_transition)
	
	# Transition fermeture
	await SceneTransition.fade_out()

	level_load_started.emit()

	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)

	# Transition ouverture
	await SceneTransition.fade_in()

	get_tree().paused = false
	await get_tree().process_frame

	level_loaded.emit()

	pass
