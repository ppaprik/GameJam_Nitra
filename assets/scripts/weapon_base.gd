extends Node2D

@export var damage = 5
@export var damage_period = 10.5
@export var bullet:PackedScene = null
@export var bullet_speed = 200
@onready var shoot_fx: AudioStreamPlayer2D = $"../Shoot_fx"

func _enter_tree() -> void:
	$Timer.wait_time = damage_period


func shoot():
	if bullet:
		
		if $Timer.is_stopped():
			$Timer.start()
			
			var bullet = bullet.instantiate()
			bullet.global_position = global_position
			bullet.velocity = Vector2(cos(rotation+get_parent().rotation), sin(rotation+get_parent().rotation))  * bullet_speed
			bullet.velocity += get_parent().velocity * 0.3
			bullet.rotation = rotation+get_parent().rotation
			
			shoot_fx.play()
			
			get_parent().get_parent().add_child(bullet)
