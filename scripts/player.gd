extends CharacterBody2D

var id : int
var world: World

func _process(delta: float):
	velocity = world.get_component(id,MovementComponent).movement_towards
	world.get_component(id, PositionComponent).value = global_position
	move_and_slide()
