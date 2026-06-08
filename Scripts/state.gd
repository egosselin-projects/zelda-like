class_name State extends Node

# Référence à l'objet joueur associé à cet état
static var player: Player

func _ready() -> void:
	pass


# Entrée dans l'état
func enter_state() -> void:
	pass


# Sortie de l'état
func exit_state() -> void:
	pass


func process(_delta: float) -> State:
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null
