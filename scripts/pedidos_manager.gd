extends Control

@export var change_interval: float = 30.0

var rng := RandomNumberGenerator.new()
var current_order: Array = []

const ING_TEXTURES := {
	"Pan": preload("res://assets/pan.png"),
	"Carne": preload("res://assets/carne.png"),
	"Lechuga": preload("res://assets/lechuga.png"),
	"Tomate": preload("res://assets/tomate.png"),
	"Queso": preload("res://assets/queso.png")
}

@onready var pedidos_hbox: HBoxContainer = $PedidosHBox
@onready var timer: Timer = $Timer

func _ready() -> void:
	rng.randomize()
	timer.wait_time = change_interval
	timer.start()
	var conn: Callable = Callable(self, "_on_Timer_timeout")
	if not timer.is_connected("timeout", conn):
		timer.timeout.connect(conn)
	_generate_new_order()

func _on_Timer_timeout() -> void:
	_generate_new_order()

func _generate_new_order() -> void:
	var middle_count: int = rng.randi_range(1, 4)
	var keys: Array = ING_TEXTURES.keys()
	var middle: Array = []
	for i in range(middle_count):
		var pick: String = str(keys[rng.randi_range(0, keys.size() - 1)])
		middle.append(pick)
	current_order = ["Pan"] + middle + ["Pan"]
	print("[Pedidos] Nuevo pedido:", current_order)
	_update_ui()

func _update_ui() -> void:
	if not is_instance_valid(pedidos_hbox):
		printerr("[Pedidos] Error: no se encontró el nodo PedidosHBox.")
		return
	for child in pedidos_hbox.get_children():
		child.queue_free()
	for ing_name in current_order:
		var tex: Texture2D = ING_TEXTURES.get(ing_name, null)
		if tex == null:
			print("[Pedidos] Texture NULL para:", ing_name)
			var fallback: VBoxContainer = VBoxContainer.new()
			fallback.custom_minimum_size = Vector2(64, 64)
			var lbl_f: Label = Label.new()
			lbl_f.text = str(ing_name)
			lbl_f.custom_minimum_size = Vector2(64, 64)
			fallback.add_child(lbl_f)
			pedidos_hbox.add_child(fallback)
			continue
		var vbox: VBoxContainer = VBoxContainer.new()
		vbox.size_flags_horizontal = Control.SIZE_FILL
		vbox.custom_minimum_size = Vector2(64, 64)
		var tr: TextureRect = TextureRect.new()
		tr.texture = tex
		tr.expand = true
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.custom_minimum_size = Vector2(64, 64)
		vbox.add_child(tr)
		var lbl: Label = Label.new()
		lbl.text = str(ing_name)
		lbl.custom_minimum_size = Vector2(64, 16)
		vbox.add_child(lbl)
		pedidos_hbox.add_child(vbox)

func get_current_order() -> Array:
	return current_order.duplicate()
