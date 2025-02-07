extends Node2D


@onready var music: AudioStreamPlayer2D = $Music


func _ready() -> void:
	music.play()
	
	
func _physics_process(delta: float) -> void:
	if Global.boss_music and !Global.changed_music:
		music.stream = load("res://assets/sounds/music/Boss Theme.mp3")
		music.play()
		Global.changed_music = true
	
	
func _on_music_finished() -> void:
	music.play()
