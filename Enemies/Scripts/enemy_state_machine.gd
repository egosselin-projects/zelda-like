class_name EnemyStateMachine extends Node

var states: Array[EnemyState]
var prev_state: EnemyState
var current_state: EnemyState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state(current_state.process(delta))
	pass


func _physics_process(delta) -> void:
	change_state(current_state.physics(delta))
	pass


func initialize(_enemy: Enemy) -> void:
	states = []

	# Réccupération des états associés à la state machine
	for child_class in get_children():
		if child_class is EnemyState:
			states.append(child_class)

	for state in states:
		state.enemy = _enemy
		state.state_machine = self
		state.init()
	
	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT


func change_state(new_state : EnemyState) -> void:
	if new_state == null || new_state == current_state:
		return
		
	#print("Slime, changement état " + new_state.name)
	
	# Au changement d'état on sort de l'état précédent
	if current_state:
		current_state.exit_state()

	# Sauvegarde de l'état précédent
	prev_state = current_state

	# Bascule sur le nouvel état
	current_state = new_state
	current_state.enter_state()
	
	
