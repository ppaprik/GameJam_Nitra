extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.launch(Vector2(cos(get_parent().rotation-1.57075) * 500, sin(get_parent().rotation-1.57075) * 500))
