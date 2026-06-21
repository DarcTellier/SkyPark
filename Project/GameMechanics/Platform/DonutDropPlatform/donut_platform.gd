extends RigidBody2D

var shake_speed 
var shake_amount 
var shake_time_limit 
var drop_delay 
var touch_to_drop 
var respawn_time 
var gravity 

var is_shaking := false
var shake_timer := 0.0
var original_x := 0.0

var player_on_platform := false
var time_stood_on := 0.0
var dropped := false

func _ready():
	shake_speed = get_parent().shake_speed
	shake_amount = get_parent().shake_amount
	shake_time_limit = get_parent().shake_time_limit
	drop_delay = get_parent().drop_delay
	touch_to_drop = get_parent().touch_to_drop
	respawn_time = get_parent().respawn_time
	gravity = get_parent().gravity
	
	original_x = position.x
	gravity_scale = 0  # Start suspended

func _physics_process(delta):
	# Handle shaking
	if is_shaking:
		shake_timer += delta
		var offset = sin(shake_timer * shake_speed * TAU) * shake_amount
		position.x = original_x + offset

		if shake_timer >= shake_time_limit:
			is_shaking = false
			position.x = original_x

	# Handle drop delay logic
	if player_on_platform and not dropped :
		time_stood_on += delta
		if time_stood_on >= drop_delay:
			drop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$B.visible = true
		$A.visible = false
		player_on_platform = true
		time_stood_on = 0.0
		start_shaking()
	if body.name == "AnimatableBody2D": 
		drop()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$B.visible = false
		$A.visible = true
		if touch_to_drop == false :
			player_on_platform = false
			time_stood_on = 0.0  # Cancel drop if player jumps off

func start_shaking():
	if not is_shaking:
		shake_timer = 0.0
		is_shaking = true

func drop():
	dropped = true
	gravity_scale = 1
	sleeping = false  # Wake up to fall
	if respawn_time > 0:
		await get_tree().create_timer(respawn_time).timeout
		spawn_new_donut()
		#queue_free()

func spawn_new_donut():
	get_parent().respawn()
