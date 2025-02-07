extends CharacterBody2D


@export var SPEED = 5000.0
@export var GRAVITY = 1000.0
@export var JUMP_VELOCITY = 20000.0

var current_planet: StaticBody2D = null
var velocity_jump: Vector2 = Vector2.ZERO
var velocity_gravity: Vector2 = Vector2.ZERO
var jumped = false

var direction_to_planet = null
var direction_up = null
var velocity_to_planet = null
var velocity_up = null


func _physics_process(delta: float) -> void:
	direction_to_planet = null
	direction_up = null
	velocity_to_planet = null
	velocity_up = null
	
	if current_planet:
		direction_to_planet = atan2(global_position.y - current_planet.global_position.y, global_position.x - current_planet.global_position.x)
		direction_up = direction_to_planet+1.57075
		velocity_to_planet = Vector2(cos(direction_to_planet), sin(direction_to_planet))
		velocity_up = Vector2(cos(direction_up), sin(direction_up))
		
		#--------------------------------------------------
		# ROTATION
		rotation = direction_to_planet+1.57075
		
		#--------------------------------------------------
		# GRAVITY
		if $Grounded.get_overlapping_bodies():
			velocity_jump = Vector2.ZERO
			velocity_gravity = Vector2.ZERO
			
			if not $Graphics.is_playing():
				$Graphics.play()
			
			# JUMP
			if Input.is_action_just_pressed("move_Jump") and velocity_jump == Vector2.ZERO:
				velocity_jump = velocity_to_planet * JUMP_VELOCITY
		else:
			velocity_gravity += velocity_to_planet * -1 * GRAVITY

		#--------------------------------------------------
		# MOVE
		var velocity_move = Vector2.ZERO
		var direction := Input.get_axis("move_L", "move_R")
		if direction:
			velocity_move += (velocity_up) * direction * SPEED
			$Graphics.flip_h = direction == -1
		
		if jumped:
			$Graphics.animation = "on_fall"
		elif (velocity_jump != Vector2.ZERO and direction) or velocity_jump != Vector2.ZERO:
			$Graphics.animation = "jump"
		elif direction:
			$Graphics.animation = "run"
		else:
			$Graphics.animation = "idle"
		
		velocity = (velocity_gravity + velocity_jump + velocity_move) * delta
		
		#print($Graphics.get_fra)

	move_and_slide()


func _on_planet_detect_area_entered(area: Area2D) -> void:
	current_planet = area.get_parent()
	
	
func _on_planet_detect_area_exited(_area: Area2D) -> void:
	current_planet = null


func _on_graphics_animation_finished() -> void:
	if $Graphics.animation == "jump":
		jumped = true
	if $Graphics.animation == "on_fall":
		jumped = false
