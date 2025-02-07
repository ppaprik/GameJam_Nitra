extends Node2D

var particles

@onready var menu_confirm: AudioStreamPlayer2D = $Menu_confirm
@onready var menu_music: AudioStreamPlayer2D = $Menu_music

func _ready():
	particles = $Vulkano.get_node_or_null("VulkanoParticles")
	if particles:
		particles.lifetime = 1.5  # Ensure particles exist before modifying
	menu_music.play()


func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("idle")


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_quit_mouse_entered() -> void:
	menu_confirm.play()


func _on_start_mouse_entered() -> void:
	menu_confirm.play()
