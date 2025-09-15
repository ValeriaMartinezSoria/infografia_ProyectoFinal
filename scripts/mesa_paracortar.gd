extends Node2D

func _ready():
	# Asume que añadiste un Area2D hijo llamado "Area2D"
	var area = $Area2D if has_node("Area2D") else null
	if area:
		area.body_entered.connect(_on_Area2D_body_entered)
		area.body_exited.connect(_on_Area2D_body_exited)
	print("[READY] mesa_paracortar inicializada:", name)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.can_cut = true
		body.cutting_station = self
		print("Jugador entró en estación de corte:", name)

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		body.can_cut = false
		body.cutting_station = null
		print("Jugador salió de estación de corte:", name)
