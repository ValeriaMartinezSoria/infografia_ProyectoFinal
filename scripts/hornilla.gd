extends Node2D

func _ready():
	var area = $Area2D if has_node("Area2D") else null
	if area:
		area.body_entered.connect(_on_Area2D_body_entered)
		area.body_exited.connect(_on_Area2D_body_exited)
	print("[READY] hornilla inicializada:", name)

func _on_Area2D_body_entered(body):
	print("Algo entró en hornilla:", body.name)  # 🔍 debug
	if body.is_in_group("player"):
		body.can_cook = true
		body.cooking_station = self
		print("Jugador entró en hornilla:", name)

func _on_Area2D_body_exited(body):
	print("Algo salió de hornilla:", body.name)  # 🔍 debug
	if body.is_in_group("player"):
		body.can_cook = false
		body.cooking_station = null
		print("Jugador salió de hornilla:", name)
