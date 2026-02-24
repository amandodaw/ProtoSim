extends CanvasLayer

var ctx: GameContext
var player_id : int = -1
@onready var hunger_label = $HungerLabel
@onready var health_label = $HealthLabel
@onready var food_label = $FoodLabel

func _process(delta):
	if ctx == null or ctx.game_state == null or player_id < 0:
		return

	var agent = ctx.game_state.get_agent(player_id)
	if agent == null:
		return

	hunger_label.text = "Hunger: " + str(int(agent.hunger))
	food_label.text = "Food: " + str(agent.food)
	health_label.text = "Health: " + str(agent.health)
