extends Node2D

var has_ingredient = false # Variable para saber si hay un ingrediente en el mesón

func _ready():
	var area = $Area2D
	if area:
		# Conectamos las señales del Area2D
		area.body_entered.connect(_on_Area2D_body_entered)
		area.body_exited.connect(_on_Area2D_body_exited)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		print("\n=== Colisión detectada ===")
		print("Jugador entró al área de un mesón")
		print("Nombre del mesón:", name)
		
		body.can_pickup = true
		body.pickup_area = self
		
		if name == "MesonPrep5":
			body.can_pickup_tomato = true
			body.can_pickup_meat = false
			body.can_pickup_lettuce = false
			body.can_pickup_cheese = false
			body.can_pickup_bread = false
			print("Es MesonPrep5 - Permitiendo interacción con tomates")
		elif name == "MesonPrep4":
			body.can_pickup_meat = true
			body.can_pickup_tomato = false
			body.can_pickup_lettuce = false
			body.can_pickup_cheese = false
			body.can_pickup_bread = false
			print("Es MesonPrep4 - Permitiendo interacción con carne")
		elif name == "MesonPrep3":
			body.can_pickup_lettuce = true
			body.can_pickup_tomato = false
			body.can_pickup_meat = false
			body.can_pickup_cheese = false
			body.can_pickup_bread = false
			print("Es MesonPrep3 - Permitiendo interacción con lechuga")
		elif name == "MesonPrep2":
			body.can_pickup_cheese = true
			body.can_pickup_tomato = false
			body.can_pickup_meat = false
			body.can_pickup_lettuce = false
			body.can_pickup_bread = false
			print("Es MesonPrep2 - Permitiendo interacción con queso")
		elif name == "MesonPrep1":
			body.can_pickup_bread = true
			body.can_pickup_tomato = false
			body.can_pickup_meat = false
			body.can_pickup_lettuce = false
			body.can_pickup_cheese = false
			print("Es MesonPrep1 - Permitiendo interacción con pan")
		# Mesones de preparación (6-9)
		elif name in ["MesonPrep6", "MesonPrep7", "MesonPrep8", "MesonPrep9"]:
			if has_ingredient:
				print("Este mesón ya tiene un ingrediente")
				body.can_pickup = false
			else:
				print("Mesón de preparación disponible para dejar ingredientes")
				body.can_pickup = true
				body.pickup_area = self
			print("Es " + name + " - Mesa de preparación")
		else:
			body.can_pickup = false
			body.can_pickup_tomato = false
			body.can_pickup_meat = false
			body.can_pickup_lettuce = false
			body.can_pickup_cheese = false
			body.can_pickup_bread = false
			print("Mesón no interactivo")
		print("========================\n")

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		print("Salió del área de meson_prep")
		if name in ["MesonPrep6", "MesonPrep7", "MesonPrep8", "MesonPrep9"]:
			# Si es un mesón de preparación, mantenemos el estado del ingrediente
			body.can_pickup = false
			body.pickup_area = null
			print("Salió del área de preparación:", name)
		else:
			# Para mesones de ingredientes, reiniciamos todo
			body.can_pickup = false
			body.pickup_area = null
			body.can_pickup_tomato = false
			body.can_pickup_meat = false
			body.can_pickup_lettuce = false
			body.can_pickup_cheese = false
			body.can_pickup_bread = false
			print("Salió del área de ingredientes:", name)
		print("pickup_area liberada")
