class_name GoapAction

var name : String
var cost : float = 1.0

var preconditions : Dictionary = {}
var effects : Dictionary = {}

func perform(world, entity): pass
func is_done(world, entity) -> bool: return false
func reset(): pass

func is_valid(state: AgentWorldStateComponent) -> bool:
	for key in preconditions:
		if state.get(key) != preconditions[key]:
			return false
	return true
	
