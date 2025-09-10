extends Button

@export var next_scene: String = "res://scenes/juego.tscn"

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	get_tree().change_scene_to_file(next_scene)
