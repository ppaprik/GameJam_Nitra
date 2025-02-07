extends Node2D


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
