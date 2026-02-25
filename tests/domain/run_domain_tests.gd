extends SceneTree


func _init() -> void:
	var suites = [
		{"name": "agent_actions", "suite": preload("res://tests/domain/test_agent_actions.gd").new()},
		{"name": "agent_chop_adjacent", "suite": preload("res://tests/domain/test_agent_chop_adjacent.gd").new()},
		{"name": "plant_growth", "suite": preload("res://tests/domain/test_plant_growth.gd").new()},
		{"name": "spawn_food_tree_conflict", "suite": preload("res://tests/domain/test_spawn_food_tree_conflict.gd").new()},
		{"name": "tree_growth", "suite": preload("res://tests/domain/test_tree_growth.gd").new()},
		{"name": "tree_chop", "suite": preload("res://tests/domain/test_tree_chop.gd").new()},
		{"name": "goap_planner", "suite": preload("res://tests/domain/test_goap_planner.gd").new()}
	]

	var failed = 0
	for item in suites:
		var ok = item["suite"].run()
		if ok:
			print("[PASS] ", item["name"])
		else:
			failed += 1
			print("[FAIL] ", item["name"])

	if failed > 0:
		push_error("Domain tests failed: %d" % failed)
		quit(1)
		return

	print("All domain tests passed")
	quit(0)
