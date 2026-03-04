class_name ActionComponent

var action_types = [
	GoToAction,
	WanderAction,
	WorkAction
]

func get_actions() -> Array[GoapAction]:
	var result : Array[GoapAction] = []
	for action_type in action_types:
		result.append(action_type.new())
	return result
