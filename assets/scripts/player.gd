extends CharacterBody2D


@export var SPEED = 5000.0
@export var GRAVITY = 1000.0
@export var JUMP_VELOCITY = 20000.0
@onready var jump_fx: AudioStreamPlayer = $Jump_fx

var current_planet: StaticBody2D = null
var velocity_jump: Vector2 = Vector2.ZERO
var velocity_gravity: Vector2 = Vector2.ZERO

var direction_to_planet = null
var direction_up = null
var velocity_to_planet = null
var velocity_up = null

var jumped = false
var jump_finished = false
var weapons = [preload("res://assets/components/weapons/bow.tscn"),  preload("res://assets/components/weapons/sword.tscn")]
var current_weapon = 0

var def_zoom = 0.04
var zoom = -def_zoom

func _ready() -> void:
	velocity = Vector2(-1000, 0)
	$CameraZoom.start()
	$Freeze.start()
	
func _physics_process(delta: float) -> void:
	if $TextureProgressBar.value != 0 and $Freeze.is_stopped():
		direction_to_planet = null
		direction_up = null
		velocity_to_planet = null
		velocity_up = null
		
		if Input.is_action_pressed("shoot"):
			$Weapon.shoot()
	
		if Input.is_action_pressed("switch_w") and $FreezeWeaponSwitch.is_stopped():
			current_weapon += 1
			if current_weapon == 2:
				current_weapon = 0
			var new_w = weapons[current_weapon].instantiate()
			new_w.name = "Weapon"
			remove_child($Weapon)
			add_child(new_w)
			$FreezeWeaponSwitch.start()
		
		var mouse_p = get_global_mouse_position()
		$Weapon.rotation = atan2(mouse_p.y - global_position.y, mouse_p.x - global_position.x) - rotation
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
				
				# JUMP
				if Input.is_action_just_pressed("move_Jump") and velocity_jump == Vector2.ZERO:
					velocity_jump = velocity_to_planet * JUMP_VELOCITY
					jump_fx.play()
			else:
				velocity_gravity += velocity_to_planet * -1 * GRAVITY
				
			#--------------------------------------------------
			# MOVE
			var velocity_move = Vector2.ZERO
			var direction := Input.get_axis("move_L", "move_R")
			if direction:
				velocity_move += (velocity_up) * direction * SPEED
				$Graphics.flip_h = direction == -1
			
			#--------------------------------------------------
			# ANIMATIONS
			if jump_finished:
				$Graphics.play("on_fall")
			elif Input.is_action_just_pressed("move_Jump") or jumped:
					jumped = true
					$Graphics.play("jump")
			elif direction:
				$Graphics.play("run")
			else:
				$Graphics.play("idle")
			
			velocity = (velocity_gravity + velocity_jump + velocity_move) * delta
			
		move_and_slide()
	else:
		if $Freeze.is_stopped():
			if global_position:
				direction_to_planet = atan2(global_position.y - current_planet.global_position.y, global_position.x - current_planet.global_position.x)
				velocity_to_planet = Vector2(cos(direction_to_planet), sin(direction_to_planet))
				velocity_gravity += velocity_to_planet * -1 * GRAVITY
				velocity = velocity_gravity * delta
		move_and_slide()

func _on_planet_detect_area_entered(area: Area2D) -> void:
		current_planet = area.get_parent()
		area.get_parent().start()

func _on_planet_detect_area_exited(_area: Area2D) -> void:
	current_planet = null

func _on_graphics_animation_finished() -> void:
	if $Graphics.animation == "jump":
		jump_finished = true
		jumped = false
	if $Graphics.animation == "on_fall":
		jump_finished = false
	if $Graphics.animation == "die":
		get_tree().change_scene_to_file("res://assets/scenes/MainMenu.tscn")

func _on_hurt_box_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	$TextureProgressBar.value = $TextureProgressBar.value - area.damage
	if area.name == "DamageBox":
		area.acknowlaged()

func _on_texture_progress_bar_value_changed(value: float) -> void:
	Global.player_health = value
	if value == 0:
		$TextureProgressBar.visible = false
		$Graphics.play("die")
		
	
func launch(new_velocity):
	$Freeze.start()
	zoom = -abs(zoom)
	$CameraZoom.start()
	velocity_jump = Vector2.ZERO
	velocity_gravity = Vector2.ZERO
	velocity = new_velocity

func _on_camera_zoom_timeout() -> void:
	if zoom > 0:
		$Camera.zoom += Vector2(zoom, zoom)
		zoom = lerp(zoom, 0.01, 0.01)
		if $Camera.zoom.x >= 2:
			$Camera.zoom = Vector2(2, 2)
			zoom = -def_zoom
		else:
			$CameraZoom.start()
	else:
		$Camera.zoom += Vector2(zoom, zoom)
		zoom = lerp(zoom, 0.01, 0.01)
		if $Camera.zoom.x <= 0.3:
			zoom = def_zoom
			$CameraPause.start()
		else:
			$CameraZoom.start()

func _on_camera_pause_timeout() -> void:
	$CameraZoom.start()
