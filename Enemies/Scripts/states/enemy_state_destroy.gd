class_name EnemyStateDestroy extends EnemyState

@export var animation_name: String = "destroy"
@export var knockback_speed: float = 200.0
@export var decelerate_speed : float = 10.0

@export_category("AI")
@export_category("Item Drops")
@export var drops: Array[DropData]

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

var _damaged_position: Vector2
var _direction: Vector2

func init() -> void:
	enemy.enemy_destroy.connect(_on_enemy_destroyed)
	pass


func _ready() -> void:
	pass


# Entrée dans l'état
func enter_state() -> void:
	enemy.invulnerable = true

	_direction = enemy.global_position.direction_to(_damaged_position)
	
	enemy.set_direction(_direction)
	enemy.velocity = _direction * -knockback_speed

	enemy.update_animation(animation_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	disable_hurt_box()
	drop_items()
	pass


# Sortie de l'état
func exit_state() -> void:
	pass


func process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null


func physics(_delta: float) -> EnemyState:
	return null


func _on_enemy_destroyed(hurt_box: HurtBox) -> void:
	_damaged_position = hurt_box.global_position
	state_machine.change_state(self)


func _on_animation_finished(_animation: String) -> void:
	enemy.queue_free()


func disable_hurt_box() -> void:
	var hurt_box: HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false
	
	
func drop_items() -> void:
	if drops.size() == 0:
		return

	for index in drops.size():
		if drops[index] == null or drops[index].item == null :
			continue

		var drop_count: int = drops[index].get_drop_count()
		for count_index in drop_count:
			var drop = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[index].item
			enemy.get_parent().call_deferred("add_child", drop)
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated(randf_range(-1.5, -1.5)) * randf_range(0.9, 1.5)

	
	
	
