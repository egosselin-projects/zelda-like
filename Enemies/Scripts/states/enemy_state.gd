class_name EnemyState extends Node

## Stocke une référence à un enemi lié a cet état
var enemy: Enemy
var state_machine: EnemyStateMachine


func init() -> void:
	pass

func _ready() -> void:
	pass


# Entrée dans l'état
func enter_state() -> void:
	pass


# Sortie de l'état
func exit_state() -> void:
	pass


func process(_delta: float) -> EnemyState:
	return null


func physics(_delta: float) -> EnemyState:
	return null


func handle_input(_event: InputEvent) -> EnemyState:
	return null
