class_name WanderAction
extends GoapAction

var target_position : Vector2i


func _init():
	name = "Wander action"
	
	preconditions = {
		"has_target": false
	}
	effects = {
		"has_target": true,
		"at_target": false
	}

func start(entity, world):
	super.start(entity, world)
	
	var pos = world.get_component(entity, PositionComponent)
	var move = world.get_component(entity, MovementComponent)
	var goal_component = world.get_component(entity, GoalComponent)
	
	var random_offset = Vector2i(
		randf_range(-100, 100),
		randf_range(-100, 100)
	)
	
	var new_target = pos.value + random_offset
	
	move.target = new_target
	
	finish()
