extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
const SPEED = 300.0
var last_direction = "down"

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
