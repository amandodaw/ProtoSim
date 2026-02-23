extends CharacterBody2D

var id : int
var world: World

func _physics_process(delta: float):
	if id==null:
		return
	velocity = world.get_component(id, MovementComponent).move
	world.get_component(id, PositionComponent).value = global_position
	move_and_slide()
