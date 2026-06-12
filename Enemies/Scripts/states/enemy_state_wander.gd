class_name EnemyStateWander extends EnemyState

@export var animation_name: String = "walk"
@export var wander_speed: float = 20.0

@export_category("AI")
@export var state_animation_duration: float = 0.5
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 3
@export var after_next_state: EnemyState

var _timer: float = 0.0
var _direction: Vector2

func init() -> void:
	pass


func _ready() -> void:
	pass


# Entrée dans l'état
func enter_state() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range(0, 3)
	_direction = enemy.DIR_4[rand]
	enemy.velocity = _direction * wander_speed
	enemy.set_direction(_direction)
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
