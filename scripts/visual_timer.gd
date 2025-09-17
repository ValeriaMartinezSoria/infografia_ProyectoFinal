extends Node2D

@export var time_per_round: int = 30
@export var rounds: int = 4

var current_time: int
var current_round: int = 1
@onready var label: Label = get_node("TimerLabelVisual")
var timer: Timer

func _ready():
	current_time = time_per_round
	
	# Configurar Label
	if label:
		label.visible = true
		label.text = ""
		label.modulate = Color(0,0,0,1)  # texto negro
		label.add_theme_font_size_override("font_size", 36)  # tamaño más pequeño

	# Crear Timer
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))
	timer.start()

	_update_label()

func _on_timer_timeout():
	if current_time > 0:
		current_time -= 1
	else:
		if current_round < rounds:
			current_round += 1
			current_time = time_per_round
		else:
			timer.stop()
	_update_label()

func _update_label():
	if label:
		label.text = "Ronda %d: %02d" % [current_round, current_time]
