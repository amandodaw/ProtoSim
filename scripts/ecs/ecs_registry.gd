class_name EcsRegistry

var _next_entity_id: int = 0
var components := {}


func create_entity() -> int:
	var id = _next_entity_id
	_next_entity_id += 1
	return id


func entity_exists(entity: int) -> bool:
	for type in components.keys():
		if components[type].has(entity):
			return true
	return false


func add(entity: int, component) -> void:
	var type = component.get_script()
	if not components.has(type):
		components[type] = {}
	components[type][entity] = component


func get_component(entity: int, type):
	if components.has(type) and components[type].has(entity):
		return components[type][entity]
	return null


func has_component(entity: int, type) -> bool:
	return components.has(type) and components[type].has(entity)


func remove_component(entity: int, type) -> void:
	if components.has(type):
		components[type].erase(entity)


func destroy_entity(entity: int) -> void:
	for type in components.keys():
		components[type].erase(entity)


func query(required_types: Array) -> Array:
	if required_types.is_empty():
		return []

	var first_type = required_types[0]
	if not components.has(first_type):
		return []

	var result: Array = []
	for entity in components[first_type].keys():
		var valid = true
		for t in required_types:
			if not has_component(entity, t):
				valid = false
				break
		if valid:
			result.append(entity)

	return result
