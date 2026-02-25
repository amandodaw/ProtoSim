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
			mov.facing = _to_cardinal(dir)
			dir = dir.normalized()
			var next_pos = body.global_position + (dir * mov.speed * delta)
			if _is_tree_blocking(ctx, next_pos):
				dir = Vector2.ZERO

		body.velocity = dir * mov.speed
		body.move_and_slide()

		pos.value = body.global_position


func _is_tree_blocking(ctx: GameContext, world_pos: Vector2) -> bool:
	if ctx.tree_tiles == null:
		return false

	var cell = ctx.tree_tiles.local_to_map(world_pos)
	var tree_id = ctx.game_state.get_tree_id_by_cell(cell)
	if tree_id == -1:
		return false

	var tree = ctx.game_state.get_tree(tree_id)
	if tree == null:
		return false

	return tree.stage >= 1


func _to_cardinal(dir: Vector2) -> Vector2:
	if absf(dir.x) >= absf(dir.y):
		return Vector2.RIGHT if dir.x >= 0.0 else Vector2.LEFT
	return Vector2.DOWN if dir.y >= 0.0 else Vector2.UP
