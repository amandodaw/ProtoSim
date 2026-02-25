extends RefCounted


class NeverDoneAction extends GoapAction:
	func _init():
		name = "never_done"

	func perform(ctx: GameContext, entity: int):
		pass

	func is_done(ctx: GameContext, entity: int) -> bool:
		return false


func run() -> bool:
	var ctx := GameContext.new()
	ctx.registry = EcsRegistry.new()

	var entity = 1
	var plan_comp := GoapPlanComponent.new()
	plan_comp.plan = [NeverDoneAction.new()]
	plan_comp.stuck_timeout = 0.5
	plan_comp.stuck_epsilon = 0.1

	var pos := PositionComponent.new()
	pos.value = Vector2(10, 10)

	ctx.registry.add(entity, plan_comp)
	ctx.registry.add(entity, IntentComponent.new())
	ctx.registry.add(entity, pos)

	var exec_system := GoapExecutionSystem.new()
	exec_system.update(ctx, 0.3)
	exec_system.update(ctx, 0.3)
	exec_system.update(ctx, 0.3)

	return plan_comp.plan.is_empty() and plan_comp.current_index == 0
