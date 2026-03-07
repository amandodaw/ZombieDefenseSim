class_name GoToAction
extends GoapAction

var target_position : Vector2


func _init():
	name = "Go to action"
	
	preconditions = {
		"has_target": true
	}
	effects = {
		"at_target": true
	}


func update(entity, world, delta):

	var pos = world.get_component(entity, PositionComponent)
	var goals = world.get_component(entity, GoalComponent).goals
	var move : MovementComponent = world.get_component(entity, MovementComponent)
	var world_state : WorldStateComponent = world.get_component(entity, WorldStateComponent)
	target_position = world_state.target_pos
	
	var direction : Vector2 = (target_position - pos.value)
	
	if direction.length() < move.speed * delta + 5.0:
		move.direction = Vector2.ZERO
		
		finish()
		return
	
	move.direction = direction.normalized()
	# Position is owned by PhysicsSystem; do not write to PositionComponent here.
