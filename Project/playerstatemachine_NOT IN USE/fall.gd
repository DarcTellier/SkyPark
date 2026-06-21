extends Node
class_name FallState

var player

func enter(_player):
	player = _player

func exit(): pass

func physics_update(delta):
	var direction = Input.get_axis("left", "right")
	var run = Input.is_action_pressed("run")
	var target_speed = (player.RUN_SPEED if run else player.WALK_SPEED) * direction

	player.velocity.x = move_toward(player.velocity.x, target_speed, player.ACCEL * delta)
	player.velocity.y += player.GRAVITY * delta
	player.velocity.y = clamp(player.velocity.y, -9999, player.MAX_FALL_SPEED)

	# Jump buffer
	if Input.is_action_just_pressed("jump"):
		player.jump_buffer_timer = player.jump_buffer_time

	# Grounded check
	if player.is_on_floor():
		if player.jump_buffer_timer > 0:
			player.change_state("JumpState")
		else:
			player.change_state("IdleState")

	player.do_move_and_slide()
