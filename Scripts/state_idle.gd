class_name State_Idle extends State

@onready var walk: State_Walk = $"../Walk"


func _ready() -> void:
	pass


# Entrée dans l'état
func enter_state() -> void:
	player.update_animation("idle")
	pass


# Sortie de l'état
func exit_state() -> void:
	pass


func process(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		return walk

	player.velocity = Vector2.ZERO
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null
