extends Camera2D

@export var player_path: NodePath

@export_category("Rooms")
@export var room_width := 576.0 # 36 * 16
@export var room_height := 352.0 # 22 * 16

@export_category("Camera Style")
@export_enum("static", "dynamic", "follow", "scroll")
var style_select := 0

@export_category("Dynamic")
@export var trans_speed := 0.5

@export_category("Follow")
@export var follow_offset := Vector2.ZERO

@export_category("Auto Scroll")
@export_enum("up", "down", "left", "right")
var scroll_direction := 3
@export var scroll_speed := 50.0

var player: Node2D
var current_room := Vector2i.ZERO
var tween: Tween


func _ready() -> void:
	player = get_node_or_null(player_path)

	if player == null:
		player = get_parent().get_node_or_null("Player")

	if player == null:
		print("Camera: No player found.")
		return

	snap_to_player_room()


func _process(delta: float) -> void:
	if player == null:
		return

	match style_select:
		0:
			static_camera()
		1:
			dynamic_camera()
		2:
			follow_camera()
		3:
			scroll_camera(delta)


func get_player_room() -> Vector2i:
	return Vector2i(
		floori(player.global_position.x / room_width),
		floori(player.global_position.y / room_height)
	)


func get_room_camera_position(room: Vector2i) -> Vector2:
	return Vector2(
		room.x * room_width,
		room.y * room_height
	)


func snap_to_player_room() -> void:
	current_room = get_player_room()
	global_position = get_room_camera_position(current_room)


func static_camera() -> void:
	var new_room := get_player_room()

	if new_room == current_room:
		return

	current_room = new_room
	global_position = get_room_camera_position(current_room)


func dynamic_camera() -> void:
	var new_room := get_player_room()

	if new_room == current_room:
		return

	current_room = new_room
	var target_pos := get_room_camera_position(current_room)

	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, trans_speed)


func follow_camera() -> void:
	global_position = player.global_position + follow_offset


func scroll_camera(delta: float) -> void:
	match scroll_direction:
		0:
			global_position.y -= scroll_speed * delta
		1:
			global_position.y += scroll_speed * delta
		2:
			global_position.x -= scroll_speed * delta
		3:
			global_position.x += scroll_speed * delta
