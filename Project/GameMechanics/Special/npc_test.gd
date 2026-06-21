
extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var speech_sound = preload("res://Assets/SoundFX/Speech.wav")


var  lines : Array[String] = [
	"Hello World",
	"It looks like everything is working"
	]


func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	
	
func on_interact():
	play_dialog()


func play_dialog():
	DialogManager.start_dialog(global_position, lines,speech_sound)
	await DialogManager.dialog_finished
