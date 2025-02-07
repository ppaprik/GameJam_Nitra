extends StaticBody2D


@export var img: Texture2D = null

var running = false

func _enter_tree() -> void:
	if img:
		$Graphics.texture = img

func _physics_process(delta: float) -> void:
	if len($EnemyCount.get_overlapping_bodies()) == 0 and running:
		$JumpPad.set_collision_mask_value(1, true)
		$JumpPad.visible = true

func start():
	$Timer.start()

func _on_timer_timeout() -> void:
	running = true
