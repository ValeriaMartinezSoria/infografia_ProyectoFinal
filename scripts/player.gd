extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
const SPEED = 300.0

func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		animation_player.play("walkRight")
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
		animation_player.play("walkLeft")
	elif Input.is_action_pressed("ui_down"):
		direction.y += 1
		animation_player.play("down")
	elif Input.is_action_pressed("ui_up"):
		direction.y -= 1
		animation_player.play("up")
	else:
		animation_player.play("RESET")
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
