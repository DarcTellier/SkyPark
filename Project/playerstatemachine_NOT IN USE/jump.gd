extends PlayerState

func enter(_player):
	super.enter(_player)

	# Drop through 2-way platform
	if Input.is_action_pressed("down") and player.two_way_platform:
		player.position.y += 1
		player.get_node("AudioStreamPlayer2D").play()
		player.change_state("FallState")
		return

	# Duck jump
	if Input.is_action_pressed("down"):
		player.velocity.y = player.JUMP_VELOCITY / player.duck_jump_height
	else:
		player.velocity.y = player.JUMP_VELOCITY

	player.get_node("AudioStreamPlayer2D").play()

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

	if player.velocity.y > 0:
		player.change_state("FallState")

	player.do_move_and_slide()
