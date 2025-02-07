extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.boss_music = true

func _physics_process(delta: float) -> void:
	if get_parent().get_node("../Graphics").animation == "die":
		get_tree().change_scene_to_file("res://assets/scenes/win.tscn")
