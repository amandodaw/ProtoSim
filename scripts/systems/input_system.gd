class_name InputSystem

func update(world : World, delta):
	for entity in world.query([InputComponent]):
		world.get_component(entity, MovementComponent).direction = get_direction()
		world.get_component(entity, IntentComponent).pick = Input.is_action_just_pressed("pick")
		world.get_component(entity, IntentComponent).eat = Input.is_action_just_pressed("eat")

func get_direction() -> Vector2i :
	var dir := Vector2i.ZERO

	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	if Input.is_action_pressed("move_up"):
		dir.y -= 1
	
	return dir
