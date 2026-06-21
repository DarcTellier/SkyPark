extends AnimatableBody2D

@export var rotation_speed := 90.0

@export_enum(
	"Stopped",
	"Clockwise",
	"CounterClockwise"
)
var start_state := 1

var mode := 0


func _ready() -> void:
	match start_state:
		0:
			mode = 0 # stopped

		1:
			mode = 1 # clockwise

		2:
			mode = 3 # counter-clockwise


func _physics_process(delta: float) -> void:

	match mode:
		1:
			rotation_degrees += rotation_speed * delta

		3:
			rotation_degrees -= rotation_speed * delta


func toggle_spin() -> void:

	mode += 1

	if mode > 3:
		mode = 0
