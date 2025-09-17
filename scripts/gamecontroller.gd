extends Node2D

@export var game_time_seconds: int = 120
var time_left: int
@onready var timer_label: Label = $TimerLabel
@onready var timer: Timer = $Timer

var score: int = 0
var pedidos: Array = []

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
	get_tree().paused = true
	var panel = $GameOverPanel
	panel.visible = true
	var label = panel.get_node("Label")
	label.visible = true
	if score >= 50:
		label.text = "¡Felicidades! Ganaste 🎉\nPuntaje final: " + str(score)
	else:
		label.text = "Lo siento, perdiste 😢\nPuntaje final: " + str(score)

func entregar_pedido(plato) -> void:
	if pedidos.is_empty():
		return
	var pedido_actual = pedidos[0]
	var ingredientes = plato.get_ingredientes()
	var valido = true
	for req in pedido_actual:
		var encontrado = false
		for ing in ingredientes:
			if ing.name == req and ing.is_cut:
				encontrado = true
				break
		if not encontrado:
			valido = false
			break
	if valido:
		score += 10
	pedidos.pop_front()
