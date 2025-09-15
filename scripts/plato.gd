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
	ingredient.position = Vector2(0, -14 * ingredients.size())
	ingredient.z_index = 20

	print("✅ Ingrediente agregado al plato:", ing_name)
	print("🍽️ Plato ahora contiene:", ingredients)
