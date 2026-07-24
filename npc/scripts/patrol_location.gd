@tool

class_name PatrolLocation extends Node2D

signal transform_changed 

@export var wait_time: float = 0.0: 
	set (value):
		wait_time = value
		_update_wait_time_label()

var target_position: Vector2 = Vector2.ZERO


func _enter_tree() -> void:
	set_notify_transform(true)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		transform_changed.emit()


func _ready() -> void:
	target_position = global_position
	_update_wait_time_label()	

	if Engine.is_editor_hint():
		return
	
	$Sprite2D.queue_free()


func update_label(_value: String) -> void:
	$Sprite2D/Label.text = _value


func update_line(next_location: Vector2) -> void:
	var line: Line2D = $Sprite2D/Line2D
	var line_points = Array(line.points)
	line_points[1] = next_location - position 
	line.points = PackedVector2Array(line_points)

func _update_wait_time_label() -> void:
	if Engine.is_editor_hint():
		$Sprite2D/Label2.text = "wait: " + str(snappedf(wait_time,0.1)) + "s"
