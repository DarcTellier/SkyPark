@tool
extends Path2D

@export var loop = false
@export var rotates = false
@export var speed = 0.5
@export var direction = false
@export var draw_line_path = true

func _ready() -> void: 
	settings()
	draw_lines()
	$PathFollow2D.rotates = rotates
	

func settings():
	$PathFollow2D.loop = loop 
	

func draw_lines():
	if draw_line_path == true:
		for i in curve.point_count:
			$Line2D.add_point(curve.get_point_position(i),i)
	

func _physics_process(delta: float) -> void:
	move_platform(delta)
	settings()


func move_platform(delta):
	if loop == false:
		if $PathFollow2D.progress_ratio >= 1:
			direction = false
		elif $PathFollow2D.progress_ratio <= 0:
			direction = true
			
		match direction:
			true: $PathFollow2D.progress_ratio += speed * delta
			false: 	$PathFollow2D.progress_ratio -= speed * delta
	
	else:
		$PathFollow2D.progress_ratio += speed * delta
	
