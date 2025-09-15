extends Node2D

var has_ingredient = false
var current_object: Node2D = null
@export var plato_scene: PackedScene = preload("res://scenes/Plato.tscn")
var plato_instance: Node2D = null

func _ready():
	var area = $Area2D
	if area:
		area.body_entered.connect(_on_Area2D_body_entered)
		area.body_exited.connect(_on_Area2D_body_exited)
	print("[READY] meson_prep inicializado:", name)

# --- Detectar jugador entrando ---
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.pickup_area = self
		body.can_pickup = true
		match name:
			"MesonPrep1":
				body.can_pickup_bread = true
			"MesonPrep2":
				body.can_pickup_cheese = true
			"MesonPrep3":
				body.can_pickup_lettuce = true
			"MesonPrep4":
				body.can_pickup_meat = true
			"MesonPrep5":
				body.can_pickup_tomato = true
			"MesonPrep6", "MesonPrep7", "MesonPrep8", "MesonPrep9":
				if has_ingredient:
					print("❌ Este mesón YA tiene un ingrediente o plato")
					body.can_pickup = false
				else:
					print("✅ Mesón de preparación disponible")
	if name.begins_with("ServStation"):
		print("Estación de servicio detectada por: ", body.name)
		body.can_serve = true
		body.serving_station = self
		print("Estación de servicio detectada")

# --- Detectar jugador saliendo ---
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		body.pickup_area = null
		body.can_pickup = false
		body.can_pickup_bread = false
		body.can_pickup_cheese = false
		body.can_pickup_lettuce = false
		body.can_pickup_meat = false
		body.can_pickup_tomato = false
		print("pickup_area liberada")
	if name.begins_with("ServStation"):
		print("Jugador salió de estación de servicio")
		body.can_serve = false
		body.serving_station = null

# --- Instanciar un plato ---
func instantiate_plate():
	if plato_instance == null:
		plato_instance = plato_scene.instantiate()
		add_child(plato_instance)
		plato_instance.position = Vector2.ZERO
		plato_instance.z_index = 10
		# Si había un ingrediente, agregarlo al plato
		if current_object != null and not current_object.name.begins_with("Plato"):
			var ingredient = current_object
			current_object = plato_instance
			ingredient.get_parent().remove_child(ingredient)
			plato_instance.add_ingredient(ingredient)
		else:
			current_object = plato_instance
		has_ingredient = true
		print("🍽 Plato instanciado en", name)
	else:
		print("❌ Ya hay un plato en este mesón")

# --- Agregar ingrediente al plato ---
func add_ingredient(ingredient: Node2D):
	if plato_instance != null:
		plato_instance.add_ingredient(ingredient)
	else:
		add_child(ingredient)
		ingredient.position = Vector2(0, -10)
		ingredient.z_index = 10
		has_ingredient = true
		current_object = ingredient
		print("Ingrediente colocado en mesón vacío:", ingredient.name)
