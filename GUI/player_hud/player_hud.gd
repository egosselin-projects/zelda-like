# Pas de class_name pour éviter les conflits avec l'autoload
extends CanvasLayer

var hearts: Array[HeartGui] = []


func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGui:
			hearts.append(child)
			child.visible = false
	pass


func update_hp(_hp: int, _max_hp: int) -> void:
	update_max_hp(_max_hp)

	# TODO: refactoriser avec un range ?
	for hp in _max_hp:
		update_heart(hp, _hp)
		pass
	pass


func update_heart(_index: int, _hp: int) -> void:
	var _value: int = clampi(_hp - _index * 2, 0, 2)
	hearts[_index].value = _value
	pass


func update_max_hp(_max_hp: int) -> void:
	var _heart_count: int = roundi(_max_hp * 0.5)
	print("_heart_count ", _heart_count)
	
	for hindex in hearts.size():
		if hindex < _heart_count:
			hearts[hindex].visible = true
			#print("hvisible true")
		else:
			hearts[hindex].visible = false
			#print("hvisible false")
	pass
