extends StaticBody2D


@export var img: Texture2D = null
@export var enemy_count = 10
@export var enemy_horde = 5
@export var enemies: Array[PackedScene] = []

var active = false

func _enter_tree() -> void:
	if img:
		$Graphics.texture = img

func _physics_process(delta: float) -> void:
	if len(enemies) != 0:
		if active:
			if enemy_count > 0 and $Spawner.is_stopped():
				var r = randi_range(0, 6.283)
				var x = global_position.x + $Collision.shape.radius * cos(r)
				var y = global_position.y + $Collision.shape.radius * sin(r)
				
				var enemy = enemies.pick_random().instanciate()
				enemy.global_position = Vector2(x, y)
				$Spawner.start()


func _on_gravity_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("in")
