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
		start()


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
	
	await get_tree().create_timer(wait_time).timeout

	if npc.do_behavior == false:
		return
	
	npc.state = "walk"
	var _direction = global_position.direction_to(target.target_position)
	npc.direction = _direction
	npc.velocity = walk_speed * _direction

	npc.update_direction(target.target_position)
	npc.update_animation()


func _get_color_by_index(color_index: int) -> Color:
	var color_count: int = COLORS.size()
	while color_index > color_count -1:
		color_index -= color_count
	
	return COLORS[color_index]




	
	
