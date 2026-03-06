class_name WanderAction
extends GoapAction

var target_position : Vector2i


func _init():
	name = "Wander action"
	
	preconditions = {
		"wander": false
	}
	effects = {
		"wander": true
	}

func start(entity, world):
	super.start(entity, world)
	
	var pos = world.get_component(entity, PositionComponent)
	var move = world.get_component(entity, MovementComponent)
	var goal_component = world.get_component(entity, GoalComponent)
	var world_state = world.get_component(entity, WorldStateComponent)
	
	var random_offset = Vector2i(
		randf_range(-100, 100),
		randf_range(-100, 100)
	)
	
	var new_target = pos.value + random_offset
	
	world_state.target_pos = new_target
	finish()
