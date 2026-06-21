extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var speech_sound = preload("res://Assets/Sound/Speech/Speech.wav")

@export var NPC_name : String
@export var request_complete:bool
@export var item_requested : String # comeback when we have type
@export var item_reward : String
@export var tada_new_item = false


@export var  initial_dialog : Array[String] = []
@export var  trade_dialog : Array[String] = []
@export var  post_dialog: Array[String] = []


var  lines : Array[String] = []



func _ready() -> void:
	if gItemCheckList.check_list[item_reward] == true:
		request_complete = true
	interaction_area.interact = Callable(self, "on_interact")
	
	
	
	
func on_interact():
	if request_complete != true:
		#Check if they have items
		if GInventory.inventory.has(item_requested) == true:
			var i = GInventory.inventory.find(item_requested,0)
			GInventory.inventory.remove_at(i)
			GInventory.inventory.insert(GInventory.inventory.size(),item_reward)
			gItemCheckList.check_list[item_reward] = true

			request_complete = true
			tada_new_item = true
			lines = trade_dialog
			play_dialog()
			return
		else:#they dont have item
			lines = initial_dialog
			play_dialog()
			return
	else:# this quest has been completed 
		lines = post_dialog
		play_dialog()
		
		
	
		
	
	
	


func play_dialog():
	DialogManager.start_dialog(global_position, lines,speech_sound)
	await DialogManager.dialog_finished
	
	if tada_new_item == true:
		#insert juicy effect
		print("TADA!!!!")
		pass
