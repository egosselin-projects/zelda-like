class_name PlayerStateMachine extends Node

var states : Array[State]
var prev_state: State
var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state(current_state.process(delta))
	pass

func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))
	pass


func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event)) 
	pass


func initialize(_player: Player) -> void:
	states = []

	# Réccupération des états associés à la state machine
	for child_class in get_children():
		if child_class is State:
			states.append(child_class)

	if states.size() > 0:
		states[0].player = _player
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT



func change_state(new_state : State) -> void:
	if new_state == null || new_state == current_state:
		return
	
	# Au changement d'état on sort de l'état précédent
	if current_state:
		current_state.exit_state()

	# Sauvegarde de l'état précédent
	prev_state = current_state

	# Bascule sur le nouvel état
	current_state = new_state
	current_state.enter_state()
