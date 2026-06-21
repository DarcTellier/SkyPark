@tool
extends StaticBody2D
@onready var interaction_area: InteractionArea = $InteractionArea

@export var treasure = "key"
@export var add_to_inventory = false
@export var is_open = false
@export var loot_text = ""

@export_enum("COMMON","RARE") var rarity = 0
@export_enum(
"WOOD_CHEST",
"FIRE_CHEST",
"WATER_CHEST",
"EARTH_CHEST",
"WIND_CHEST",
"LIGHT_CHEST",
"DARK_CHEST",
"COPPER_CHEST",
"SILVER_CHEST",
"GOLD_CHEST",
"SPECIAL_CHEST",
"PINK_CHEST"
) var chest_type = 0

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	select_chest()

func select_chest():
	match chest_type:
		0: $ChestSpriteSheet.frame = 0
		1: $ChestSpriteSheet.frame = 4
		2: $ChestSpriteSheet.frame = 8
		3: $ChestSpriteSheet.frame = 12
		4: $ChestSpriteSheet.frame = 16
		5: $ChestSpriteSheet.frame =20
		6: $ChestSpriteSheet.frame =24
		7: $ChestSpriteSheet.frame =28
		8: $ChestSpriteSheet.frame =32
		9: $ChestSpriteSheet.frame =36
		10: $ChestSpriteSheet.frame =40
		11: $ChestSpriteSheet.frame =44
	
	match rarity:
		0:return
		1:$ChestSpriteSheet.frame += 2	


func on_interact():
	open_chest()
	
	
	
func open_chest():
	if is_open == false:
		$ChestSpriteSheet.frame+= 1
		is_open = true
		$LootDialogue/Control/Panel/VBoxContainer/VBoxContainer2/LOOT.text = loot_text
		$LootDialogue.show()
		if add_to_inventory == true:
			GPlayer.inventory_insert(treasure)
		
	
