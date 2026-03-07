class_name WorldStateComponent

var target_pos : Vector2 = Vector2.ZERO

var state : Dictionary = {
	"has_target" : false,
	"at_target" : false,
	"enough_resources" : false,
	"wander" : false,
	"state_dirty": false
}
