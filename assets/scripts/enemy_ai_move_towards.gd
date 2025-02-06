extends Node2D

var parent = null

func _enter_tree() -> void:
	parent = get_parent()

func _physics_process(delta: float) -> void:
	if parent.current_player:
		parent.move(1)
