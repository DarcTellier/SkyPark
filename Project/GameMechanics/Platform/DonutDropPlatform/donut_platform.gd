extends RigidBody2D

@export var shake_speed := 8.0
@export var shake_amount := 2.0
@export var shake_time_limit := 0.5

@export var drop_delay := 0.5
@export var touch_to_drop := false
@export var respawn_time := 3.0
@export var fall_gravity := 1.0

var is_shaking := false
var shake_timer := 0.0
var original_x := 0.0
var original_position := Vector2.ZERO

var player_on_platform := false
var time_stood_on := 0.0
var dropped := false


func _ready() -> void:
	original_position = position
	original_x = position.x
	gravity_scale = 0.0
	freeze = true


func _physics_process(delta: float) -> void:
	if is_shaking and not dropped:
		shake_timer += delta
		var offset := sin(shake_timer * shake_speed * TAU) * shake_amount
		position.x = original_x + offset

		if shake_timer >= shake_time_limit:
			is_shaking = false
			position.x = original_x

	if player_on_platform and not dropped:
		time_stood_on += delta

		if time_stood_on >= drop_delay:
			drop()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if has_node("B"):
			$B.visible = true

		if has_node("A"):
			$A.visible = false

		player_on_platform = true
		time_stood_on = 0.0
		start_shaking()

		if touch_to_drop:
			drop()

	if body is AnimatableBody2D:
		drop()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if has_node("B"):
			$B.visible = false

		if has_node("A"):
			$A.visible = true

		if not touch_to_drop:
			player_on_platform = false
			time_stood_on = 0.0


func start_shaking() -> void:
	if dropped:
		return

	shake_timer = 0.0
	is_shaking = true


func drop() -> void:
	if dropped:
		return

	dropped = true
	is_shaking = false
	player_on_platform = false

	freeze = false
	gravity_scale = fall_gravity
	sleeping = false

	if respawn_time > 0.0:
		await get_tree().create_timer(respawn_time).timeout
		respawn()


func respawn() -> void:
	position = original_position
	rotation = 0.0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

	gravity_scale = 0.0
	freeze = true
	sleeping = true

	dropped = false
	is_shaking = false
	shake_timer = 0.0
	time_stood_on = 0.0
	player_on_platform = false

	if has_node("B"):
		$B.visible = false

	if has_node("A"):
		$A.visible = true
