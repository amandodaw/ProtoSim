class_name GoapPlanComponent

var plan : Array = []
var current_index : int = 0
var stuck_time : float = 0.0
var last_position : Vector2 = Vector2.ZERO
var has_last_position : bool = false
var last_action_index : int = -1
var stuck_epsilon : float = 1.0
var stuck_timeout : float = 1.2
