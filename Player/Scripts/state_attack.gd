class_name State_Attack extends State

@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animation_player_attack: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@export var attack_sound: AudioStream
@export_range(1,20,0.5) var decelerate_speed: float = 5.0

var attacking: bool = false

func _ready() -> void:
	pass


# Entrée dans l'état
func enter_state() -> void:
	print("entrée état attaque")
	player.update_animation("attack")
	animation_player_attack.play("attack_" + player.animation_direction())
	# Listener sur la fin de l'animation
	animation_player.animation_finished.connect(end_attack)
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()

	attacking = true

	# Délai court pour ne pas détruire l'objet immédiatement
	await get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true
	pass


# Sortie de l'état
func exit_state() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurt_box.monitoring = false
	pass


func process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null


func end_attack(_new_anim_name: String) -> void:
	attacking = false
