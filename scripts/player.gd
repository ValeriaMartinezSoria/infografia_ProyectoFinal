extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
const SPEED = 300.0
var last_direction = "down"

var carrying_object = null
var can_pickup = false
var pickup_area = null
var can_pickup_tomato = false
var can_pickup_meat = false
var can_pickup_lettuce = false
var can_pickup_cheese = false
var can_pickup_bread = false

func _ready():
	print("\n=== Inicializando Player ===")
	print("Nodo actual:", name)
	# Añadir el grupo 'player' a este nodo para facilitar la detección
	add_to_group("player")
	print("\n=== Inicialización completada ===\n")

func _physics_process(_delta):
	var dir = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		dir.x += 1
		animation_player.play("walkRight")
		last_direction = "right"
	elif Input.is_action_pressed("ui_left"):
		dir.x -= 1
		animation_player.play("walkLeft")
		last_direction = "left"
	elif Input.is_action_pressed("ui_down"):
		dir.y += 1
		animation_player.play("down")
		last_direction = "down"
	elif Input.is_action_pressed("ui_up"):
		dir.y -= 1
		animation_player.play("up")
		last_direction = "up"
	else:
		animation_player.stop()
		match last_direction:
			"right":
				animation_player.play("walkRight")
				animation_player.seek(0, true)
			"left":
				animation_player.play("walkLeft")
				animation_player.seek(0, true)
			"up":
				animation_player.play("up")
				animation_player.seek(0, true)
			"down":
				animation_player.play("down")
				animation_player.seek(0, true)

	if dir != Vector2.ZERO:
		dir = dir.normalized()
		velocity.x = dir.x * SPEED
		velocity.y = dir.y * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("Grab"):
		print("Presionaste Grab")
		if carrying_object == null:
			# Primero revisamos si estamos en un mesón de preparación con un ingrediente
			if pickup_area and pickup_area.name in ["MesonPrep6", "MesonPrep7", "MesonPrep8", "MesonPrep9"] and pickup_area.has_ingredient:
				print("Recogiendo ingrediente del mesón de preparación")
				# Buscamos el ingrediente en la escena
				var possible_ingredients = get_parent().get_children()
				for child in possible_ingredients:
					# Verificamos si es un ingrediente y está en la posición del mesón
					if child is Node2D and (
						child.name.begins_with("Tomato") or 
						child.name.begins_with("Carne") or 
						child.name.begins_with("Lechuga") or 
						child.name.begins_with("Queso") or 
						child.name.begins_with("Pan")):
						if child.global_position.distance_to(pickup_area.global_position) < 50:  # Si está cerca del mesón
							carrying_object = child
							var global_pos = carrying_object.global_position
							carrying_object.get_parent().remove_child(carrying_object)
							add_child(carrying_object)
							carrying_object.position = Vector2(119, 46)
							carrying_object.z_index = self.z_index + 1
							pickup_area.has_ingredient = false
							print("Ingrediente recogido de", pickup_area.name)
							break
			elif can_pickup_tomato:
				print("Instanciando tomate")
				var tomato_scene = preload("res://scenes/Tomato.tscn")
				carrying_object = tomato_scene.instantiate()
				add_child(carrying_object)
				carrying_object.position = Vector2(119, 46) # Misma posición que el Sprite2D del jugador
				carrying_object.z_index = self.z_index + 1
				print("Tomate instanciado como hijo del jugador en ", carrying_object.position)
			elif can_pickup_meat:
				print("Instanciando carne")
				var meat_scene = preload("res://scenes/Carne.tscn")
				carrying_object = meat_scene.instantiate()
				add_child(carrying_object)
				carrying_object.position = Vector2(119, 46) # Misma posición que el Sprite2D del jugador
				carrying_object.z_index = self.z_index + 1
				print("Carne instanciada como hijo del jugador en ", carrying_object.position)
			elif can_pickup_lettuce:
				print("Instanciando lechuga")
				var lettuce_scene = preload("res://scenes/Lechuga.tscn")
				carrying_object = lettuce_scene.instantiate()
				add_child(carrying_object)
				carrying_object.position = Vector2(119, 46)
				carrying_object.z_index = self.z_index + 1
				print("Lechuga instanciada como hijo del jugador en ", carrying_object.position)
			elif can_pickup_cheese:
				print("Instanciando queso")
				var cheese_scene = preload("res://scenes/Queso.tscn")
				carrying_object = cheese_scene.instantiate()
				add_child(carrying_object)
				carrying_object.position = Vector2(119, 46)
				carrying_object.z_index = self.z_index + 1
				print("Queso instanciado como hijo del jugador en ", carrying_object.position)
			elif can_pickup_bread:
				print("Instanciando pan")
				var bread_scene = preload("res://scenes/Pan.tscn")
				carrying_object = bread_scene.instantiate()
				add_child(carrying_object)
				carrying_object.position = Vector2(119, 46)
				carrying_object.z_index = self.z_index + 1
				print("Pan instanciado como hijo del jugador en ", carrying_object.position)
		elif carrying_object != null and pickup_area != null and can_pickup:
			var meson_name = pickup_area.name
			# Si es un mesón de preparación (6-9)
			if meson_name in ["MesonPrep6", "MesonPrep7", "MesonPrep8", "MesonPrep9"]:
				if not pickup_area.has_ingredient:
					print("Soltando objeto en el mesón de preparación")
					# Guardamos la escala y posición global actual
					var global_pos = carrying_object.global_position
					carrying_object.get_parent().remove_child(carrying_object)
					get_parent().add_child(carrying_object)  # Lo añadimos al nodo raíz primero
					carrying_object.global_position = pickup_area.global_position  # Lo posicionamos en el centro del mesón
					carrying_object.position.y -= 20  # Ajustamos un poco hacia arriba para que se vea bien
					carrying_object.z_index = 10  # Aseguramos que esté por encima de todo
					pickup_area.has_ingredient = true
					carrying_object = null
					print("Ingrediente colocado en el centro de", meson_name)
				else:
					print(meson_name, "ya tiene un ingrediente")
			# Si es un mesón de ingredientes (1-5)
			elif can_pickup_tomato or can_pickup_meat or can_pickup_lettuce or can_pickup_cheese or can_pickup_bread:
				print("Soltando objeto en el mesón de ingredientes")
				carrying_object.get_parent().remove_child(carrying_object)
				get_parent().add_child(carrying_object)
				carrying_object.position = pickup_area.global_position
				carrying_object = null
				print("Ingrediente devuelto al mesón original")
	# El tomate sigue al jugador automáticamente por ser hijo

func _on_Area2D_body_entered(body):
	print("\n=== Colisión detectada ===")
	if body.is_in_group("player"):
		print("Jugador entró al área de un mesón")
		# La señal viene del Area2D del mesón, así que obtenemos el padre directamente
		var meson = self.get_parent()
		print("Nombre del mesón:", meson.name)
		
		# Solo permitir tomates en MesonPrep5
		if meson.name == "MesonPrep5":
			pickup_area = meson
			can_pickup = true
			can_pickup_tomato = true
			can_pickup_meat = true # Permitir recoger carne también
			can_pickup_lettuce = true # Permitir recoger lechuga
			print("Es MesonPrep5 - Permitiendo interacción con tomates, carne y lechuga")
		else:
			can_pickup = false
			can_pickup_tomato = false
			can_pickup_meat = false # No permitir recoger carne
			can_pickup_lettuce = false # No permitir recoger lechuga
			print("No es MesonPrep5 - No se permite interacción con tomates")
	print("========================\n")

func _on_Area2D_body_exited(body):
	print("Salió del área de meson_prep")
	can_pickup = false
	pickup_area = null
	can_pickup_tomato = false
	can_pickup_meat = false # Reiniciar también al salir
	can_pickup_lettuce = false # Reiniciar también al salir
	print("pickup_area liberada")
