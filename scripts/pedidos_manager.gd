extends Control

@export var change_interval: float = 30.0
var rng := RandomNumberGenerator.new()
var current_order: Array = []
var pedido_entregado: bool = false

const ING_TEXTURES := {
	"Pan": preload("res://assets/pan.png"),
	"Carne": preload("res://assets/carne.png"),
	"Lechuga": preload("res://assets/lechuga.png"),
	"Tomate": preload("res://assets/tomate.png"),
	"Queso": preload("res://assets/queso.png")
}

@onready var pedidos_hbox: HBoxContainer = $PedidosHBox
@onready var timer: Timer = $Timer
@onready var root_scene = get_tree().current_scene

func _ready():
	rng.randomize()
	timer.wait_time = change_interval
	timer.start()
	timer.timeout.connect(Callable(self, "_on_Timer_timeout"))
	_generate_new_order()

func _on_Timer_timeout() -> void:
	if not pedido_entregado and current_order.size() > 0:
		var score_label = get_tree().current_scene.get_node("Control/ScoreLabel")
		if score_label:
			var current_score = int(score_label.text)
			current_score -= 5
			score_label.text = str(current_score)
	_generate_new_order()
	timer.start()

func _generate_new_order() -> void:
	pedido_entregado = false
	var middle_count: int = rng.randi_range(1, 4)
	var keys: Array = ING_TEXTURES.keys()
	keys.erase("Pan")
	var middle: Array = []
	for i in range(middle_count):
		middle.append(keys[rng.randi_range(0, keys.size() - 1)])
	current_order = ["Pan"] + middle + ["Pan"]
	_update_ui()

func _update_ui() -> void:
	for child in pedidos_hbox.get_children():
		child.queue_free()
	for ing_name in current_order:
		var vbox: VBoxContainer = VBoxContainer.new()
		vbox.custom_minimum_size = Vector2(64,64)
		var tex: Texture2D = ING_TEXTURES.get(ing_name,null)
		var tr: TextureRect = TextureRect.new()
		tr.texture = tex
		tr.expand = true
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.custom_minimum_size = Vector2(64,64)
		vbox.add_child(tr)
		var lbl: Label = Label.new()
		lbl.text = ing_name
		lbl.custom_minimum_size = Vector2(64,16)
		vbox.add_child(lbl)
		pedidos_hbox.add_child(vbox)

func validate_order(plato: Node) -> bool:
	if plato == null:
		return false
	
	var plate_ingredients: Array = []
	for ing in plato.ingredients:
		if ing.begins_with("Pan"): plate_ingredients.append("Pan")
		elif ing.begins_with("Queso"): plate_ingredients.append("Queso")
		elif ing.begins_with("Lechuga"): plate_ingredients.append("Lechuga")
		elif ing.begins_with("Tomate"): plate_ingredients.append("Tomate")
		elif ing.begins_with("Carne"): plate_ingredients.append("Carne")

	if plate_ingredients == current_order:
		pedido_entregado = true
		_generate_new_order()
		timer.start()
		return true
	else:
		return false
