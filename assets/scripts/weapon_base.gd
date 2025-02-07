extends Node2D

@export var damage = 5
@export var damage_period = 0.5
@export var bullet:PackedScene = null
@export var bullet_speed = 200

func _enter_tree() -> void:
	$Timer.wait_time = damage_period


func shoot():
	if bullet:
		
		if $Timer.is_stopped():
			$Timer.start()
			
			var bullet = bullet.instantiate()
			bullet.global_position = global_position
			bullet.velocity = Vector2(cos(rotation+get_parent().rotation), sin(rotation+get_parent().rotation))  * bullet_speed
			bullet.rotation = rotation+get_parent().rotation
			
			get_parent().get_parent().add_child(bullet)
