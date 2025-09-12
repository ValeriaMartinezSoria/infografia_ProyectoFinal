extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
const SPEED = 300.0
var last_direction = "down"

var carrying_object = null
var can_pickup = false
var pickup_area = null
var can_pickup_tomato = false

func _ready():
	print("\n=== Inicializando Player ===")
	print("Nodo actual:", name)
	print("Nodos hijos del jugador:", get_children())
	
	# Conectar señales de todas las Area2D de los mesones prep
	var parent = get_parent().get_parent() # Obtenemos el nodo Juego
	print("Nodo padre (Juego):", parent.name)
	print("\nBuscando mesones prep...")
	
	for child in parent.get_children():
		if child.name.begins_with("MesonPrep"):
			print("\nEncontrado mesón:", child.name)
			# Buscamos el StaticBody2D y Area2D dentro del mesón
			var static_body = child.get_node_or_null("StaticBody2D")
			var area = child.get_node_or_null("Area2D")
			
			if static_body:
				print("- StaticBody2D encontrado")
			else:
				print("ERROR: No se encontró StaticBody2D en", child.name)
				
			if area:
				print("- Area2D encontrada")
				print("- Collision Layer:", area.collision_layer)
				print("- Collision Mask:", area.collision_mask)
				# Desconectamos primero por si acaso
				if area.is_connected("body_entered", Callable(self, "_on_Area2D_body_entered")):
					area.disconnect("body_entered", Callable(self, "_on_Area2D_body_entered"))
				if area.is_connected("body_exited", Callable(self, "_on_Area2D_body_exited")):
					area.disconnect("body_exited", Callable(self, "_on_Area2D_body_exited"))
					
				var result = area.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
				if result == OK:
					print("- Señal body_entered conectada correctamente")
				else:
					print("- Error al conectar body_entered")
				
				result = area.connect("body_exited", Callable(self, "_on_Area2D_body_exited"))
				if result == OK:
					print("- Señal body_exited conectada correctamente")
				else:
					print("- Error al conectar body_exited")
			else:
				print("ERROR: No se encontró Area2D en", child.name)
	
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
	# Solo permitir agarrar tomate si está en MesonPrep5 y presiona 'G'
	if Input.is_action_just_pressed("Grab"):
		print("Presionaste Grab")
		if carrying_object == null and can_pickup_tomato:
			print("Instanciando tomate")
			var tomato_scene = preload("res://scenes/Tomato.tscn")
			carrying_object = tomato_scene.instantiate()
			add_child(carrying_object)
			carrying_object.position = Vector2(119, 46) # Misma posición que el Sprite2D del jugador
			carrying_object.z_index = self.z_index + 1
			print("Tomate instanciado como hijo del jugador en ", carrying_object.position)
		elif carrying_object != null and can_pickup_tomato:
			print("Soltando tomate en el meson")
			carrying_object.get_parent().remove_child(carrying_object)
			get_parent().add_child(carrying_object)
			carrying_object.position = pickup_area.global_position
			print("Tomate soltado en ", carrying_object.position)
			carrying_object = null
	# El tomate sigue al jugador automáticamente por ser hijo

func _on_Area2D_body_entered(body):
	print("\n=== Colisión detectada ===")
	print("Entró al área: ", body.name)
	print("Tipo de cuerpo:", body.get_class())
	print("Grupos del cuerpo:", body.get_groups())
	can_pickup = true
	pickup_area = body.get_parent()
	print("pickup_area asignada a:", pickup_area.name)
	can_pickup_tomato = true
	print("can_pickup_tomato =", can_pickup_tomato)
	print("========================\n")

func _on_Area2D_body_exited(body):
	print("Salió del área de meson_prep")
	can_pickup = false
	pickup_area = null
	can_pickup_tomato = false
	print("pickup_area liberada")
