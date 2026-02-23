class_name PhysicsSystem

func update(world, delta):

	for e in world.query([
		MovementComponent,
		CharacterBodyComponent,
		PositionComponent
	]):

		var mov = world.get_component(e, MovementComponent)
		var body = world.get_component(e, CharacterBodyComponent).body
		var pos = world.get_component(e, PositionComponent)

		var dir = mov.move
		if dir != Vector2.ZERO:
			dir = dir.normalized()

		body.velocity = dir * mov.speed
		body.move_and_slide()

		pos.value = body.global_position
