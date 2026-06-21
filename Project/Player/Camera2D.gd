extends Camera2D

var player_position
var screen_size
var first_camera_correction = true



@export_category("CameraStyle")
@export_enum("static","dynamic","follow","scroll") var style_select
var cam_move_style_choice = ["static","dynamic", "follow","scroll"]
var cam_move_style_select

@export_category("Dynamic")
@export var start_offset = -116
@export var trans_speed = 0.5

@export_enum("TRANS_BACK","TRANS_BOUNCE","TRANS_CIRC","TRANS_CUBIC","TRANS_ELASTIC","TRANS_EXPO","TRANS_LINEAR","TRANS_QUAD","TRANS_QUART","TRANS_QUINT","TRANS_SINE") var trans_select
@export_enum("EASE_IN","EASE_IN_OUT","EASE_OUT","EASE_OUT_IN") var ease_select




@export_category("CAMERAFOLLOW")
@export var camera_smooth_speed = 1
@export var camera_smooth_toggle = true
@export var offset_position = Vector2 (0,16) 


@export_category("AUTOSCROLL")
@export_enum("up","down","left","right","up_left", "up_right", "down_left", "down_right") var scroll_direction = 3 
@export var scroll_Speed = 50 # 150 should be the fastest

 


func _ready():
	screen_size = get_viewport_rect().size
	get_player_position()
	
	

	
func _process(delta):
	get_player_position()
	MoveCam(delta)



func get_player_position():
	player_position = get_parent().get_node("Player").global_position
	
 


func MoveCam(delta):
	
	cam_move_style_select = cam_move_style_choice[style_select] 
	
	
	match cam_move_style_select:
		"static":static_cam_movement()
		"dynamic":dynamic_cam_movement()
		"follow":follow_player_movement()
		"scroll":scroll_cam(delta)
		
		_:
			static_cam_movement()
			print("error cam movement")
	
	



func static_cam_movement():
	

	if player_position.y < position.y:
		position.y -= (screen_size.y /2) 
		offset.y +=4
	
	if player_position.y > position.y + (screen_size.y /2):
		position.y += (screen_size.y /2)
		offset.y -=4
		
	if player_position.x < position.x:
		position.x -= (screen_size.x /2)
	
	if player_position.x > position.x +(screen_size.x /2):
		position.x += (screen_size.x /2)
		
	camera_room_correction_x()
	camera_room_correction_y()
	


func dynamic_cam_movement():



	if player_position.y < position.y:
		position.y -= (screen_size.y /2) 
		offset.y +=4
	
	if player_position.y > position.y + (screen_size.y /2):
		position.y += (screen_size.y /2) 
		offset.y -=4
	
	
		
	if player_position.x < position.x:
		var pos = position.x - (screen_size.x /2)
		var field ="position:x"
		camera_tween_transition(field,pos)
		
	if player_position.x > position.x +(screen_size.x /2):
		var pos = position.x + (screen_size.x /2)
		var field ="position:x"
		camera_tween_transition(field,pos)
	
	
	camera_room_correction_x()
	camera_room_correction_y()	
	



func camera_tween_transition(field,pos):
	var tween : Tween
	tween = create_tween()
	
	var trans = TransEaseSelect.select_trans(trans_select)
	var ease = TransEaseSelect.select_ease(ease_select)
	
	tween.tween_property( self, field, pos, trans_speed).set_trans(trans).set_ease(ease_select)
	




		
	
func follow_player_movement():
	#for in town or special areas 
	# make sure to put in variables to control camera positions
	camera_smooth_speed =1
	camera_smooth_toggle = true
	
	position = player_position
	
	position.x = player_position.x -(screen_size.x /4)
	#position.y = player_position.y -(screen_size.y /5) + offset_position.y 
	
#	camera_room_correction_y()



func scroll_cam(delta):
	
	match scroll_direction:
		3: position.x += scroll_Speed * delta 
	
	



# camera corrections

func camera_room_correction_x():
	
	var pos = (int(player_position.x /(36 *16))*576)
	var field ="position:x"
	
	if cam_move_style_select == "dynamic" ||first_camera_correction == true :
		camera_tween_transition(field,pos)
		first_camera_correction = false



	
func camera_room_correction_y():
	var pos = int(player_position.y + (22 *16))/(352)
	var field ="position:y"
	


	
	
	
	

# for detecting when player is wedge between 2 bodies
func _on_static_body_2d_body_entered(body):
	if body.name == "Player":
		print("player sucks")
	pass # Replace with function body.
