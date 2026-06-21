extends Node

#quit game 
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

	#test Stuff
	if event.is_action_pressed("Reset_scene"):
		get_tree().reload_current_scene() 
	#
	#if event.is_action_pressed("lol"):
		#print("🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮")
		#
