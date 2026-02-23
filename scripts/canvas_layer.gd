extends CanvasLayer

var player_data : HumanData
@onready var hunger_label = $HungerLabel
@onready var health_label = $HealthLabel
@onready var food_label = $FoodLabel

func _process(delta):
	if player_data == null:
		return

	hunger_label.text = "Hunger: " + str(int(player_data.hunger))
	food_label.text = "Food: " + str(int(player_data.food))
	health_label.text = "Health: " + str(player_data.health)
