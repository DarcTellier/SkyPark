extends CharacterBody2D

@export var SPEED := 300.0
@export var JUMP_VELOCITY := -400.0
@export var duck_jump_height := 2
@export var cayote_Time := 10
@export var horizontal_velocity := 0
@export var input_freeze := false

var cayote_count := 0
var jump := false
var up_press := false
var down_press := false
var left_press := false
var right_press := false

var in_pipe_transit := false
var two_way_platform := false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


var state = null
var states = {}

func _ready():
	PauseScreen.player_reff = self
	GPipeNetwork.emergency_player_reff = self

	states = {
		"IdleState": preload("res://playerstatemachine/idle.gd").new(),
		"MoveState": preload("res://playerstatemachine/move.gd").new(),
		"JumpState": preload("res://playerstatemachine/jump.gd").new(),
		"FallState": preload("res://playerstatemachine/fall.gd").new(),
	}
	change_state("IdleState")

func _physics_process(delta):
	update_gravity(delta)
	cayote_time()
	if !input_freeze:
		state.physics_update(delta)
	regular_inputs()

func change_state(state_name):
	if state:
		state.exit()
	state = states[state_name]
	state.enter(self)

func update_gravity(delta):
	if !is_on_floor():
		velocity.y += gravity * delta

func do_move_and_slide():
	super.move_and_slide()

func cayote_time():
	if is_on_floor():
		jump = true
		cayote_count = 0
	else:
		cayote_count += 1
		if cayote_count >= cayote_Time:
			jump = false

func regular_inputs():
	up_press = Input.is_action_pressed("up")
	down_press = Input.is_action_pressed("down")
	left_press = Input.is_action_pressed("left")
	right_press = Input.is_action_pressed("right")
