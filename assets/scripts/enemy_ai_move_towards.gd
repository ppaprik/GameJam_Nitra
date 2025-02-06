extends Node2D

var parent = null

func _enter_tree() -> void:
	parent = get_parent()

func _physics_process(delta: float) -> void:
	if parent.current_player:
		parent.move(sign(parent.direction_to_planet - parent.current_player.direction_to_planet) * -1)
	else:
		parent.move(0)
