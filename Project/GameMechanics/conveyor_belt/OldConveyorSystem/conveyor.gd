extends AnimatableBody2D


var speed = 500
var drop_off = 100
var max_distance = 0
var reset_position = 9696

func _physics_process(delta):
	position.x -= speed * delta
	
	
	
	if position.x <= max_distance:
		position.x  = reset_position 
		
	
	
