class_name ActionSystem

var food_tilemap : TileMapLayer


func pick_food(entity_data):
	if food_tilemap.get_cell_source_id(food_tilemap.local_to_map(entity_data.global_position))!= -1:
		food_tilemap.erase_cell(food_tilemap.local_to_map(entity_data.global_position))
		entity_data.food += 1
		print("food picked")

func eat_food(entity_data):
	if entity_data.food >0 && entity_data.hunger < 150:
		entity_data.food -= 1
		entity_data.hunger += 50
