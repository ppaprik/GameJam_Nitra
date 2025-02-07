extends StaticBody2D


@export var img: Texture2D = null


func _enter_tree() -> void:
	if img:
		$Graphics.texture = img
