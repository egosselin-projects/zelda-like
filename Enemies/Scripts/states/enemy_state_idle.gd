class_name EnemyStateIdle extends EnemyState

@export var animation_name: String = "idle"

@export_category("AI")
@export var state_duration_min: float = 0.5
@export var state_duration_max: float = 1.5
@export var after_next_state: EnemyState

var _timer: float = 0.0


func init() -> void:
	pass


func _ready() -> void:
	pass


# Entrée dans l'état
func enter_state() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.update_animation(animation_name)
	pass


# Sortie de l'état
func exit_state() -> void:
	pass


func process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return after_next_state
	return null


func physics(_delta: float) -> EnemyState:
	return null
