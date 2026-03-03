class_name PhysicsSystem

func update(world, delta):

	for e in world.query([
		MovementComponent,
		SpriteComponent,
		PositionComponent
	]):

		var mov = world.get_component(e, MovementComponent)
		var sprite = world.get_component(e, SpriteComponent).sprite
		var pos = world.get_component(e, PositionComponent)

		var dir = mov.direction
		if dir != Vector2.ZERO:
			dir = dir.normalized()
		
		if sprite==null:
			continue
		var sprite_velocity = dir * mov.speed
		sprite.global_position += sprite_velocity * delta

		pos.value = sprite.global_position
