class_name ItemEffectHeal extends ItemEffect

@export var heal_ammount: int = 1
@export var sound: AudioStream

func use() -> void:
	PlayerManager.player.update_hp(heal_ammount)
	PauseMenu.play_sound(sound)
