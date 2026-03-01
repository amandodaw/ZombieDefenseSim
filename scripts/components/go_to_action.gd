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
	var move : MovementComponent = world.get_component(entity, MovementComponent)
	target_position = move.target
	
	var direction = (target_position - pos.value)
	
	if direction.length() < 2:
		finish()
		return
	
	move.direction = target_position - pos.value
