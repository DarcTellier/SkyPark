extends PlayerState

func physics_update(delta):
	var direction = Input.get_axis("left", "right")

	if direction != 0:
		player.change_state("MoveState")

	if Input.is_action_just_pressed("jump") and player.jump:
		player.change_state("JumpState")

	if !player.is_on_floor():
		player.change_state("FallState")

	player.do_move_and_slide()
