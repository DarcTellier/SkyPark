@tool
extends Node2D

@export var lift_speed := 4.0
var direction = null
var platforms = [] 
var first = true



func _ready() -> void:
	check_direction()
	_find_platforms()
	var spacing = $end.position.x/ platforms.size()
	for i in platforms.size():
		platforms[i].position.x = spacing*i


func _physics_process(delta):
	if first == false:
		check_direction()
		match direction:
			"left":	move_left()
			"right":move_right()
			_:print("conveyor Stopped")
			

	first = false

func check_direction():
	if $end.position.x <0:
		direction = "left"
	elif $end.position.x >0:
		direction = "right"
	elif $end.position.x == 0:
		direction = "stop"	
		
	
func move_left():
	for i in platforms.size():
		platforms[i].position.x -= lift_speed
		if platforms[i].position.x < $end.position.x:
			platforms[i].get_node("CollisionShape2D").disabled = true
			platforms[i].position.x = 0
			platforms[i].get_node("CollisionShape2D").disabled = false
		
		if platforms[i].position.x >0:
			platforms[i].position.x = $end.position.x

func move_right():
	for i in platforms.size():
		platforms[i].position.x += lift_speed
		if platforms[i].position.x > $end.position.x:
			platforms[i].get_node("CollisionShape2D").disabled = true
			platforms[i].position.x = 0
			platforms[i].get_node("CollisionShape2D").disabled = false
		
		if platforms[i].position.x < 0:
			platforms[i].position.x = $end.position.x

func _find_platforms():
	platforms = []
	for child in get_children():
		if child.is_in_group("platforms"):
			platforms.insert(platforms.size(), child)
