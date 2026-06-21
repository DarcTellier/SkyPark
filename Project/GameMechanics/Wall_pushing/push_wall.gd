extends Node2D

var player_reff: Node2D = null
var is_thrusting := false

@export var thrust_time := 0.8  # Time to smash down
@export var retract_time := 3.2  # Time to return
@export var wait_before_retract := 0.3

var thrust_tween: Tween = null
var retract_tween: Tween = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_reff = body
		if not is_thrusting:
			thrust()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_reff = null

func thrust():
	is_thrusting = true
	if retract_tween: retract_tween.kill()

	thrust_tween = create_tween()
	thrust_tween.tween_property($AnimatableBody2D, "position", $End.position, thrust_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	thrust_tween.play()

	# Start retract timer after hitting bottom
	await thrust_tween.finished
	await get_tree().create_timer(wait_before_retract).timeout
	retract()

func retract():
	if thrust_tween: thrust_tween.kill()

	retract_tween = create_tween()
	retract_tween.tween_property($AnimatableBody2D, "position", get_parent().position, retract_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	retract_tween.play()

	await retract_tween.finished
	is_thrusting = false

	# If player is still there, repeat
	if player_reff:
		thrust()
