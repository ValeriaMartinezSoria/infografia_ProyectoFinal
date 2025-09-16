extends Node2D

var is_cut: bool = false
var is_cooked: bool = false

func cut() -> void:
	if is_cut:
		return
	is_cut = true
	var spr = get_node_or_null("Sprite2D")
	if spr:
		spr.modulate = Color(0.55, 0.55, 0.55) # grisáceo para cortado
	print("Ingrediente cortado:", name)

func cook() -> void:
	# Solo la carne puede cocinarse
	if not name.begins_with("Carne"):
		print("Este ingrediente no se puede cocinar:", name)
		return

	if is_cooked:
		return
	is_cooked = true
	var spr = get_node_or_null("Sprite2D")
	if spr:
		spr.modulate = Color(0.8, 0.4, 0.1) # marrón rojizo = cocinado
	print("Ingrediente cocinado:", name)
