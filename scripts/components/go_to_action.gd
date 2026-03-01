class_name GoToAction
extends GoapAction

var target_position : Vector2i


func _init():
	name = "Go to action"
	
	preconditions = {
		"has_target": true
	}
	effects = {
		"at_target": true,
		"move_to_target": true
	}


func update(entity, world, delta):

	var pos = world.get_component(entity, PositionComponent)
	var goals = world.get_component(entity, GoalComponent).goals
	var move : MovementComponent = world.get_component(entity, MovementComponent)
	target_position = move.target
	
	var direction : Vector2 = (target_position - pos.value)
	
	if direction.length() < move.speed * delta + 5:
		move.direction = Vector2.ZERO
		goals.get("move_to_target", false)
		finish()
		return
	
	move.direction = direction.normalized()
	pos.value += Vector2i(move.direction * move.speed * delta)
