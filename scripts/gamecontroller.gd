extends Node2D

@export var game_time_seconds: int = 120  # 2 minutos
var time_left: int
@onready var timer_label: Label = $TimerLabel
@onready var timer: Timer = $Timer

func _ready():
	time_left = game_time_seconds
	timer.wait_time = 1.0
	timer.start()
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))
	_update_ui()

func _on_timer_timeout():
	if time_left > 0:
		time_left -= 1
		_update_ui()
	else:
		timer.stop()
		_pause_game()

func _update_ui():
	var minutes = int(time_left / 60)
	var seconds = int(time_left % 60)

	var min_text = str(minutes) if minutes >= 10 else "0" + str(minutes)
	var sec_text = str(seconds) if seconds >= 10 else "0" + str(seconds)

	timer_label.text = min_text + ":" + sec_text


func _pause_game():
	print("⏰ Tiempo terminado! Juego pausado")
	get_tree().paused = true
