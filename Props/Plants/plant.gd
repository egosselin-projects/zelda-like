class_name Plant extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitBox.damaged.connect(take_damage)
	pass # Replace with function body.
 
# Underscore pour param optionnel
func take_damage(_damage: int) -> void:
	queue_free()
	pass
