extends CharacterBody2D


@export var SPEED: int = 5000
@export var GRAVITY: int = 1000
@export var JUMP_VELOCITY: int = 20000
@export var DETECTION_RANGE: int = 100
@export var damage = 5
@export var attack_period = 0.5

var current_player: CharacterBody2D = null
var current_planet: StaticBody2D = null
var velocity_gravity: Vector2 = Vector2.ZERO
var velocity_jump: Vector2 = Vector2.ZERO

var direction_to_planet = null
var direction_up = null
var velocity_to_planet = null
var velocity_up = null

var move_direction: int = 0
var move_jump: bool = false

func _enter_tree() -> void:
	$PlayerDetect/CollisionShape2D.shape.radius = DETECTION_RANGE
	$DamageBox.damage = damage
	$AttackWait.wait_time = attack_period

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
		
		# ROTATION
		rotation = direction_to_planet+1.57075
		
		# GRAVITY
		if $Grounded.is_colliding():
			velocity_jump = Vector2.ZERO
			velocity_gravity = Vector2.ZERO
			# JUMP
			if move_jump and velocity_jump == Vector2.ZERO:
				velocity_jump = velocity_to_planet * JUMP_VELOCITY
				move_jump = false
		else:
			velocity_gravity += velocity_to_planet * -1 * GRAVITY
			
		# MOVE
		var velocity_move = Vector2.ZERO
		if move_direction:
			$SideDetect.target_position.x = move_direction * 10
			if $SideDetect.target_position.x == 0:
				$SideDetect.target_position.x = -10
			$Graphics.flip_h = move_direction == -1
			
			if not $SideDetect.is_colliding():
				velocity_move += (velocity_up) * move_direction * SPEED
		
		velocity = (velocity_gravity + velocity_jump + velocity_move) * delta
	
	if not current_player:
		pass
		
	
	move_and_slide()

func _on_planet_detect_area_entered(area: Area2D) -> void:
	current_planet = area.get_parent()

func _on_planet_detect_area_exited(_area: Area2D) -> void:
	current_planet = null

func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		current_player = body

func _on_player_detect_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		current_player = null

func _on_attack_wait_timeout() -> void:
	$DamageBox.set_collision_layer_value(5, true)

func move(direction: int):
	move_direction = direction

func jump():
	move_jump = true
