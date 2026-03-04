class_name WorkAction
extends GoapAction

var target_position : Vector2i


func _init():
	name = "Work action"
	
	preconditions = {
		"at_target": true
	}
	effects = {
		"enough_resources": true
	}

func start(entity, world):
	super.start(entity, world)

func update(entity, world, delta):
	pass
