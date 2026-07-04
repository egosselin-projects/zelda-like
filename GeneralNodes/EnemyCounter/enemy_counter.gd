class_name EnemyCounter extends Node

signal enemies_defeated


func _ready() -> void:
	child_exiting_tree.connect(_on_enemy_destroyed)


func _on_enemy_destroyed(node: Node2D) -> void:
	if node is Enemy:
		# Si on en arribe au denier enemi
		if enemy_count() <= 1:
			enemies_defeated.emit()


func enemy_count() -> int:
	var _count: int = 0

	for child in get_children():
		if child is Enemy:
			_count += 1
		
	return _count
