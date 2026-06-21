extends CharacterBody2D
class_name Player
# Hinkel Dinkheimer

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var horizontal_velocity = 0 

@export var cayote_Time = 10
var cayote_count= 0

@export var default_movevent = true
@export var ladder_movement = false

@export var input_freeze = false
@export var is_jump = false
@export var duck_jump_height = 2

@export var up_press = false
@export var down_press = false
@export var left_press = false
@export var right_press = false

var in_pipe_transit = false
var two_way_platform = false
var turn_off_gravity = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity  = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = default_gravity


func _ready() -> void:
	PauseScreen.player_reff = self #pass refference to self to Pause screen for magic
	GPipeNetwork.emergency_player_reff = self # fix issue with pipe not getting player refference on pipe body enter. 

func _physics_process(delta):
	
	update_gravity(delta)
	cayote_time()
	player_input()
	GPlayer.current_elevation(global_position.y) # level on display 

func player_input():
	if input_freeze == false:
		jump_input()
		switchboard()
		regular_inputs()


func switchboard():
	if default_movevent == true:
		$Movement.movement_input()
	if ladder_movement == true:
		$Ladder.movement_input()
		
	 


func jump_input():

	#2wayPlatforms
	if Input.is_action_pressed("down")&&Input.is_action_just_pressed("jump")&& is_jump == true && two_way_platform == true:
		position.y+=1
		$AudioStreamPlayer2D.play()
		return
	#small jump
	if Input.is_action_pressed("down")&&Input.is_action_just_pressed("jump")&& is_jump == true:
		velocity.y = JUMP_VELOCITY / duck_jump_height
		$AudioStreamPlayer2D.play()
		return	
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump")&& is_jump == true :  
		jump()

func jump():
	velocity.y = JUMP_VELOCITY
	$AudioStreamPlayer2D.play()



	
	

func update_gravity(delta):
	# Add the gravity.
	if not is_on_floor ():
		velocity.y += gravity* delta
		
		
func cayote_time():
	if is_on_floor() == true:
		is_jump = true
		cayote_count = 0
	
	else:
		cayote_count += 1
		if cayote_count >= cayote_Time:
			is_jump = false





func regular_inputs():
	if Input.is_action_pressed("down"):
		down_press = true
	if Input.is_action_just_released("down"):
		down_press = false	
		
	if Input.is_action_pressed("up"):
		up_press = true
	if Input.is_action_just_released("up"):
		up_press = false	
	
	if Input.is_action_pressed("left"):
		left_press = true
	if Input.is_action_just_released("left"):
		left_press = false	
	
	if Input.is_action_pressed("right"):
		right_press = true
	if Input.is_action_just_released("right"):
		right_press = false	
