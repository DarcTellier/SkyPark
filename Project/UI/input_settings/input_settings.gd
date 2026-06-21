extends Control

@onready var input_button_scene = preload("res://UI/input_settings/input_button.tscn")
@onready var action_list  = $Panel/MarginContainer/VBoxContainer/ScrollContainer/ActionList


var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"up": "UP",
	"down":"DOWN",
	"left":"LEFT",
	"right":"RIGHT",
	"jump":"JUMP",
	"interact":"INTERACT",
	"pause": "PAUSE"
	 
}

func _ready() -> void:
	_create_action_list()
	

func _create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:	
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() >0:
			input_label.text = ""
		else:	
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button,action))
		
func _on_input_button_pressed(button,action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."
			




func _input(event: InputEvent) -> void:
	if is_remapping:
		if (
			event is InputEventKey ||
			event is InputEventJoypadButton ||
			(event is InputEventJoypadMotion and abs(event.axis_value) > 0.5) ||
			(event is InputEventMouseButton and event.pressed)
		):
			# Turns double click into single click
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			if event.as_text() == "Escape":
				return

			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)

			is_remapping = false
			action_to_remap = null
			remapping_button = null
	



func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")
	
	if event.as_text().containsn("Joypad"):
		print("Joy")
	
	print(event.as_text())


func _on_reset_button_pressed() -> void:
	_create_action_list()


#TODO fix the text from joypad to fit input label
func fix_joy_pad_text (text): 

	
	pass
#Joypad Motion on Axis 1 (Left Stick Y-Axis, Joystick 0 Y-Axis) with Value -0.61
#Joypad Motion on Axis 1 (Left Stick Y-Axis, Joystick 0 Y-Axis) with Value 0.71
#Joypad Motion on Axis 0 (Left Stick X-Axis, Joystick 0 X-Axis) with Value -0.53
#Joypad Motion on Axis 0 (Left Stick X-Axis, Joystick 0 X-Axis) with Value 0.57
#Joypad Button 0 (Bottom Action, Sony Cross, Xbox A, Nintendo B)
#Joypad Button 2 (Left Action, Sony Square, Xbox X, Nintendo Y)
#Joypad Button 3 (Top Action, Sony Triangle, Xbox Y, Nintendo X)
#Joypad Button 1 (Right Action, Sony Circle, Xbox B, Nintendo A)
#Joypad Motion on Axis 3 (Right Stick Y-Axis, Joystick 1 Y-Axis) with Value -0.53
#Joypad Motion on Axis 3 (Right Stick Y-Axis, Joystick 1 Y-Axis) with Value 0.55
#Joypad Motion on Axis 2 (Right Stick X-Axis, Joystick 1 X-Axis) with Value -0.53
#Joypad Motion on Axis 2 (Right Stick X-Axis, Joystick 1 X-Axis) with Value 0.56
#Joypad Button 11 (D-pad Up)
#Joypad Button 12 (D-pad Down)
#Joypad Button 13 (D-pad Left)
#Joypad Button 14 (D-pad Right)
#Joypad Motion on Axis 4 (Joystick 2 X-Axis, Left Trigger, Sony L2, Xbox LT) with Value 0.61
#Joypad Motion on Axis 5 (Joystick 2 Y-Axis, Right Trigger, Sony R2, Xbox RT) with Value 0.56
#Joypad Button 4 (Back, Sony Select, Xbox Back, Nintendo -)
#Joypad Button 6 (Start, Xbox Menu, Nintendo +)
#Joypad Button 7 (Left Stick, Sony L3, Xbox L/LS)
#Joypad Button 8 (Right Stick, Sony R3, Xbox R/RS)
