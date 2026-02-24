class_name DomainEventBus

var _events: Array = []


func publish(event: Dictionary) -> void:
	_events.append(event)


func pop_all() -> Array:
	var all = _events.duplicate()
	_events.clear()
	return all
