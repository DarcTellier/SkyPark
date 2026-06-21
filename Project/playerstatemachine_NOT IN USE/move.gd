extends PlayerState

func physics_update(delta):
	var direction = Input.get_axis("left", "right")

	if direction < 0:
		player.get_node("Sprite").flip_h = true
	elif direction > 0:
		player.get_node("Sprite").flip_h = false

	if direction != 0:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, player.horizontal_velocity, player.SPEED)

	if Input.is_action_just_pressed("jump") and player.jump:
		player.change_state("JumpState")

	if !player.is_on_floor():
		player.change_state("FallState")

	player.do_move_and_slide()
