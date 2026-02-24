class_name SystemScheduler

var systems: Array = []


func register_system(system) -> void:
	systems.append(system)


func tick(ctx: GameContext, delta: float) -> void:
	for system in systems:
		system.update(ctx, delta)
