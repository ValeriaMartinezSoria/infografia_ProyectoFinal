extends Node2D

var is_cut: bool = false

func cut() -> void:
	if is_cut:
		return
	is_cut = true
	var spr = get_node_or_null("Sprite2D")
	if spr:
		spr.modulate = Color(0.55, 0.55, 0.55)
	print("Ingrediente cortado (script):", name)
