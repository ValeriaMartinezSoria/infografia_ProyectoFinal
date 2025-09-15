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
var score = 0

var can_cut: bool = false
var cutting_station = null
var _cut_timer: float = 0.0
const CUT_REQUIRED: float = 2.0

var hold_offset: Vector2 = Vector2(0, -10)

func _ready():
	add_to_group("player")

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
			"right": animation_player.play("walkRight"); animation_player.seek(0,true)
			"left": animation_player.play("walkLeft"); animation_player.seek(0,true)
			"up": animation_player.play("up"); animation_player.seek(0,true)
			"down": animation_player.play("down"); animation_player.seek(0,true)

	if dir != Vector2.ZERO:
		dir = dir.normalized()
		velocity = dir * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("Grab") and pickup_area != null:
		if carrying_object == null:
			if pickup_area.name in ["MesonPrep6","MesonPrep7","MesonPrep8","MesonPrep9"] and pickup_area.has_ingredient:
				for child in get_parent().get_children():
					if child is Node2D and (child.name.begins_with("Tomato") or child.name.begins_with("Carne") or child.name.begins_with("Lechuga") or child.name.begins_with("Queso") or child.name.begins_with("Pan")):
						if child.global_position.distance_to(pickup_area.global_position) < 50:
							_pickup_object(child)
							pickup_area.has_ingredient = false
							break
			elif can_pickup_tomato:
				_spawn_ingredient("res://scenes/Tomato.tscn")
			elif can_pickup_meat:
				_spawn_ingredient("res://scenes/Carne.tscn")
			elif can_pickup_lettuce:
				_spawn_ingredient("res://scenes/Lechuga.tscn")
			elif can_pickup_cheese:
				_spawn_ingredient("res://scenes/Queso.tscn")
			elif can_pickup_bread:
				_spawn_ingredient("res://scenes/Pan.tscn")
		else:
			var target = pickup_area.current_object if pickup_area.current_object != null else pickup_area
			_drop_object(target)

	if Input.is_action_just_pressed("instantiate_plate") and pickup_area != null and pickup_area.name in ["MesonPrep6","MesonPrep7","MesonPrep8","MesonPrep9"]:
		if pickup_area.current_object == null or not pickup_area.current_object.name.begins_with("Plato"):
			var plato_scene: PackedScene = preload("res://scenes/Plato.tscn")
			var plato_instance = plato_scene.instantiate()
			pickup_area.add_child(plato_instance)
			plato_instance.global_position = pickup_area.global_position + Vector2(0, -20)
			plato_instance.z_index = 20
			plato_instance.visible = true
			pickup_area.current_object = plato_instance
			pickup_area.has_ingredient = true

	if Input.is_action_just_pressed("ui_select") and pickup_area != null:
		if carrying_object == null:
			if pickup_area.current_object != null and pickup_area.current_object.name.begins_with("Plato"):
				_pickup_object(pickup_area.current_object)
				pickup_area.current_object = null
				pickup_area.has_ingredient = false

	if Input.is_action_just_pressed("ServeButton"):
		if carrying_object != null and carrying_object.name.begins_with("Plato"):
			var root_scene = get_tree().current_scene
			var pedidos_manager1 = root_scene.get_node_or_null("Control/PedidosPanel1")
			var pedidos_manager2 = root_scene.get_node_or_null("Control/PedidosPanel2")
			var score_label = root_scene.get_node_or_null("Control/ScoreLabel")
			var pedido_valido = false

			if pedidos_manager1 != null:
				if pedidos_manager1.validate_order(carrying_object):
					pedido_valido = true
			if pedidos_manager2 != null:
				if !pedido_valido and pedidos_manager2.validate_order(carrying_object):
					pedido_valido = true

			if pedido_valido:
				score += 10
			else:
				score -= 10

			if score_label != null:
				score_label.text = str(score)

			if carrying_object != null:
				carrying_object.queue_free()
				carrying_object = null

	if can_cut and carrying_object != null and (carrying_object.name.begins_with("Tomato") or carrying_object.name.begins_with("Lechuga")):
		if Input.is_action_pressed("cut"):
			_cut_timer += _delta
			if _cut_timer >= CUT_REQUIRED:
				if carrying_object.has_method("cut"):
					carrying_object.cut()
				else:
					var spr = carrying_object.get_node_or_null("Sprite2D")
					if spr:
						spr.modulate = Color(1, 0.6, 0.6)
				carrying_object.set_meta("is_cut", true)
				_cut_timer = 0.0
		else:
			_cut_timer = 0.0
	else:
		_cut_timer = 0.0

func _pickup_object(obj: Node2D):
	carrying_object = obj
	if carrying_object.get_parent() != null:
		carrying_object.get_parent().remove_child(carrying_object)
	add_child(carrying_object)
	carrying_object.position = hold_offset
	carrying_object.z_index = 50

func _spawn_ingredient(path:String):
	var scene: PackedScene = load(path)
	var ingredient = scene.instantiate()
	_pickup_object(ingredient)

func _drop_object(target):
	if carrying_object == null:
		return
	if carrying_object.get_parent() != null:
		carrying_object.get_parent().remove_child(carrying_object)
	if target.has_method("add_ingredient"):
		target.add_ingredient(carrying_object)
	else:
		target.add_child(carrying_object)
		carrying_object.position = Vector2.ZERO
		carrying_object.z_index = 10
		target.has_ingredient = true
	carrying_object = null

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		pickup_area = self
		can_pickup = true
		match name:
			"MesonPrep1": body.can_pickup_bread = true
			"MesonPrep2": body.can_pickup_cheese = true
			"MesonPrep3": body.can_pickup_lettuce = true
			"MesonPrep4": body.can_pickup_meat = true
			"MesonPrep5": body.can_pickup_tomato = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		pickup_area = null
		can_pickup = false
		body.can_pickup_bread = false
		body.can_pickup_cheese = false
		body.can_pickup_lettuce = false
		body.can_pickup_meat = false
		body.can_pickup_tomato = false
