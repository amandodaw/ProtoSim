extends CharacterBody2D

var id : int
var world

func _process(delta: float):
	velocity = data.desired_position
	data.position = position
	data.global_position = global_position
	move_and_slide()
