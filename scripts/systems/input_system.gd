class_name InputSystem

var action_system : ActionSystem

func player_process(player_data: HumanData):
	get_direction(player_data)
	get_action(player_data)
	
func get_direction(player: HumanData):
	var dir := Vector2i.ZERO

	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	if Input.is_action_pressed("move_up"):
		dir.y -= 1
	
	player.desired_position = dir*player.speed

func get_action(player: HumanData):
	if Input.is_action_pressed("pick"):
		action_system.pick_food(player)
	if Input.is_action_pressed("eat"):
		action_system.eat_food(player)
