@tool

extends NPCBehavior

const COLORS = [
	Color(1,0,0),
	Color(1,1,0),
	Color(0,1,0),
	Color(0,1,1),
	Color(0,0,1),
	Color(1,0,1)
]

@export var walk_speed: float = 30.0

var patrol_locations: Array[PatrolLocation]
var current_location_index: int = 0
var target: PatrolLocation

var has_started: bool = false
var last_phase: String
var direction: Vector2

@onready var timer: Timer = $Timer


func _ready() -> void:
	gather_patrol_locations()

	if Engine.is_editor_hint():
		child_entered_tree.connect(gather_patrol_locations)
		child_order_changed.connect(gather_patrol_locations)
		return
	
	super()
	if patrol_locations.size() == 0:
		# Arrêt du script
		process_mode = Node.PROCESS_MODE_DISABLED
		return

	target = patrol_locations[0]


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	# Quand le npc atteind le noeud, on relance le start pour continuer le movement
	if npc.global_position.distance_to(target.target_position) < 1:
		idle_phase()


func gather_patrol_locations(_node: Node = null) -> void:
	patrol_locations = []
	
	for child in get_children():
		if child is PatrolLocation:
			patrol_locations.append(child)
	
	if Engine.is_editor_hint():
		if patrol_locations.size() > 0:
			for patrol_point_index in patrol_locations.size():
				var patrol_point = patrol_locations[patrol_point_index] as PatrolLocation
				
				if not patrol_point.transform_changed.is_connected(gather_patrol_locations):
					patrol_point.transform_changed.connect(gather_patrol_locations)
				
				patrol_point.update_label(str(patrol_point_index))
				patrol_point.modulate = _get_color_by_index(patrol_point_index)
				
				var next_patrol_point: PatrolLocation
				if patrol_point_index < patrol_locations.size() -1:
					next_patrol_point = patrol_locations[patrol_point_index + 1]
				else:
					next_patrol_point = patrol_locations[0]

				patrol_point.update_line(next_patrol_point.position)


func start() -> void:
	if npc.do_behavior == false or patrol_locations.size() < 2:
		return

	if has_started:
		if timer.time_left == 0:
			walk_phase()
		return # la phase idle attends encore la fin du timeout

	has_started = true
	idle_phase()
	


func idle_phase() -> void:
	npc.global_position = target.target_position
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	
	var wait_time: float = target.wait_time

	current_location_index += 1
	if current_location_index >= patrol_locations.size():
		# Retour au noeuf initial quand on arrive au dernier noeud de la liste
		current_location_index = 0
	 
	target = patrol_locations[current_location_index]
	
	if wait_time > 0:
		timer.start(wait_time)
		await timer.timeout


	if npc.do_behavior == false:
		return

	walk_phase()


func walk_phase() -> void:
	npc.state = "walk"
	direction = global_position.direction_to(target.target_position)
	npc.direction = direction
	npc.velocity = walk_speed * direction

	npc.update_direction(target.target_position)
	npc.update_animation()


func _get_color_by_index(color_index: int) -> Color:
	var color_count: int = COLORS.size()
	while color_index > color_count -1:
		color_index -= color_count
	
	return COLORS[color_index]




	
	
