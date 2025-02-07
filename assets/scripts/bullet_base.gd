extends CharacterBody2D

@export var GRAVITY = 250.0
var current_planet = null

func _physics_process(delta: float) -> void:
	var direction_to_planet = atan2(global_position.y - current_planet.global_position.y, global_position.x - current_planet.global_position.x)
	var velocity_to_planet = Vector2(cos(direction_to_planet), sin(direction_to_planet))
	velocity += velocity_to_planet * -1 * GRAVITY * delta
	rotation = velocity.angle()
	
	move_and_slide()

func _on_planet_detect_area_entered(area: Area2D) -> void:
	current_planet = area.get_parent()


func _on_planet_hit_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	get_parent().call_deferred("remove_child", self)
