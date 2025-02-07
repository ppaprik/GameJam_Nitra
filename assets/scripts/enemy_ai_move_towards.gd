extends Node2D

var parent = null

func _enter_tree() -> void:
	parent = get_parent()

func _physics_process(_delta: float) -> void:
	if parent.current_player:
		var angle_diff = parent.current_player.direction_to_planet - parent.direction_to_planet
		# normalize angle
		if angle_diff > PI:
			angle_diff -= 2 * PI
		elif angle_diff < -PI:
			angle_diff += 2 * PI
			
		if abs(angle_diff) > 0.01:
			parent.move(sign(angle_diff))
		else:
			parent.move(0)
	else:
		parent.move(0)
