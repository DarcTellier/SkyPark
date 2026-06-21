extends AnimatableBody2D
var turnOn = false
var change = false

var direction = 0
var up = false
var right = false
var down = false
var left = false

var speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if up == true:
		position.y -= speed * delta
	if down == true:
		position.y += speed * delta
	
	if left == true:
		position.x -= speed * delta
	if right == true:
		position.x += speed * delta		
	
	
	


func _on_area_2d_body_entered(body):
	if turnOn == true && change == true:
		#change direction
		change_direction()
		change = false
	elif turnOn == false && change == true:
		up = true
		turnOn = true
	



func _on_area_2d_body_exited(body):
	change = true
	stop_platform()
	


func change_direction():
	direction += 1
	if direction >=4:
		direction = 0 
	
	reset_directions()
	match direction:
		0:
			up = true
			$DirectionalLiftUp.visible = true
		1:
			right = true
			$DirectionalLiftRight.visible = true
		2:
			down = true
			$DirectionalLiftDown.visible = true
		3:
			left = true
			$DirectionalLiftLeft.visible = true
		

func reset_directions():
	
	up = false
	right = false
	down = false
	left = false
	
	$DirectionalLiftUp.visible = false
	$DirectionalLiftRight.visible = false
	$DirectionalLiftDown.visible = false
	$DirectionalLiftLeft.visible = false
			
		
func stop_platform():
	up = false
	right = false
	down = false
	left = false
