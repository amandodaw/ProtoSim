class_name PhysicsSystem

func update(ctx: GameContext, delta: float):

	for e in ctx.registry.query([
		MovementComponent,
		CharacterBodyComponent,
		PositionComponent
	]):

		var mov = ctx.registry.get_component(e, MovementComponent)
		var body = ctx.registry.get_component(e, CharacterBodyComponent).body
		var pos = ctx.registry.get_component(e, PositionComponent)

		var dir = mov.direction
		if dir != Vector2.ZERO:
			dir = dir.normalized()

		body.velocity = dir * mov.speed
		body.move_and_slide()

		pos.value = body.global_position
