class_name VisionComponent

var range : int = 4

# resultado percepción
var visible_entities : Array[int] = []

# staggered update
var update_interval : float = 0.3
var time_until_update : float = 0.0


func randomize_timer():
	time_until_update = randf() * update_interval
