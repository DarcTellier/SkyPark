extends AnimatableBody2D

@export var speed := 4.0

@export_category("Auto Return")
@export var return_to_ground := true
@export var return_delay := 10.0
@export var return_when_player_near_base := true

var min_height: Vector2
var max_height: Vector2
var inside_elevator := false
var player_near_base := false
var idle_timer := 0.0


func _ready() -> void:
	min_height = get_parent().get_node("MinHeight").position
	max_height = get_parent().get_node("MaxHeight").position


func _physics_process(delta: float) -> void:
	var player_using := false

	if inside_elevator:
		if Input.is_action_pressed("up"):
			move_up()
			player_using = true

		if Input.is_action_pressed("down"):
			move_down()
			player_using = true

	if player_using:
		idle_timer = 0.0
	else:
		idle_timer += delta

	if return_to_ground:
		if idle_timer >= return_delay:
			return_to_ground_floor()

		if return_when_player_near_base and player_near_base:
			return_to_ground_floor()


func move_up() -> void:
	if position.y >= max_height.y:
		position.y -= speed
		if position.y < max_height.y:
			position.y = max_height.y


func move_down() -> void:
	if position.y <= min_height.y:
		position.y += speed
		if position.y > min_height.y:
			position.y = min_height.y


func return_to_ground_floor() -> void:
	if position.y < min_height.y:
		move_down()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		inside_elevator = true
		idle_timer = 0.0


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		inside_elevator = false
		idle_timer = 0.0


func _on_base_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_near_base = true


func _on_base_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_near_base = false
