extends Node2D

var ingredients: Array = []

func add_ingredient(ingredient: Node2D) -> void:
	if ingredient == null:
		return

	var ing_name = ingredient.name
	ingredients.append(ing_name)

	if ingredient.get_parent():
		ingredient.get_parent().remove_child(ingredient)
	add_child(ingredient)

	# Centrar en X y apilar en Y, el primer ingrediente en el centro
	var idx = ingredients.size() - 1
	var base_y = 0  # Cambia este valor si el centro visual del plato no es Y=0
	var y_offset = -18 * idx  # Ajusta 18 para más o menos separación
	ingredient.position = Vector2(0, base_y + y_offset)
	ingredient.z_index = 20 + idx

	# Si el ingrediente es Sprite2D, asegúrate que esté centrado
	if ingredient.has_method("set_centered"):
		ingredient.set_centered(true)

	print("✅ Ingrediente agregado al plato:", ing_name)
	print("🍽️ Plato ahora contiene:", ingredients)
