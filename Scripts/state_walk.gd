class_name State_Walk extends State

@export var move_speed : float = 100.0
@onready var idle: State_Idle = $"../Idle"


func _ready() -> void:
	pass


# Entrée dans l'état
func enter_state() -> void:
	print("entrée état marche")
	player.update_animation("walk")
	pass


# Sortie de l'état
func exit_state() -> void:
	pass


func process(_delta: float) -> State:
	# Renvoi de l'état idle si pas de mouvement
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed

	if player.set_direction():
		player.update_animation("walk")

	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null
