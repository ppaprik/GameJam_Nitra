extends Node2D

var particles


func _ready():
	particles = $Vulkano.get_node_or_null("VulkanoParticles")
	particles.lifetime = 1.5

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("idle")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
