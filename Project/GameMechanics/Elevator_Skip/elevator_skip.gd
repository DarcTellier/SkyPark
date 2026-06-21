@tool
extends Node2D

@export var lift_speed := 4.0
var platforms = [] 
var first = true


func _ready() -> void:
	_find_platforms()
	var spacing = $end.position.y/ platforms.size()
	for i in platforms.size():
		platforms[i].position.y = spacing*i


func _physics_process(delta):
	if first == false:
		lift()
	first = false

	
func lift():
	for i in platforms.size():
		platforms[i].position.y -= lift_speed
		if platforms[i].position.y < $end.position.y:
			platforms[i].get_node("CollisionShape2D").disabled = true
			platforms[i].position.y = 0
			platforms[i].get_node("CollisionShape2D").disabled = false
		
		if platforms[i].position.y >0:
			platforms[i].position.y = $end.position.y


func _find_platforms():
	platforms = []
	for child in get_children():
		if child.is_in_group("platforms"):
			platforms.insert(platforms.size(), child)
