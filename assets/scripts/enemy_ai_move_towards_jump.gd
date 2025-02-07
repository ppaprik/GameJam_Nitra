extends Node2D

var parent = null

func _enter_tree() -> void:
	parent = get_parent()
	
	var timer = Timer.new()
	timer.name = "PatrolTimer"
	timer.wait_time = 1
	timer.connect("timeout", on_patrol_timer_timeout)
	add_child(timer)

func _physics_process(_delta: float) -> void:
	if parent.current_player:
		var angle_diff = parent.current_player.direction_to_planet - parent.direction_to_planet
		# normalize angle
		if angle_diff > PI:
			angle_diff -= 2 * PI
		elif angle_diff < -PI:
			angle_diff += 2 * PI
		
		parent.jump()
		if abs(angle_diff) > 0.01:
			parent.move(sign(angle_diff))
		else:
			parent.move(0)
	else:
		if $PatrolTimer.is_stopped():
			$PatrolTimer.start()
	parent.jump()

func on_patrol_timer_timeout():
	var random_val = randi() % 4
	
	if random_val == 0:
		parent.move(1)
	elif random_val == 1:
		parent.move(-1)
	else:
		parent.move(0)
