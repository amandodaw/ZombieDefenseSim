class_name GoapExecutionSystem


func update(world: World, delta):

	for entity in world.query([
		PlanComponent,
		WorldStateComponent,
		GoalComponent,
		MovementComponent
	]):
		var plan : Array[GoapAction] = world.get_component(entity, PlanComponent).plan
		if plan.is_empty():
			continue
		
		var action : GoapAction = plan[0]
		
		# iniciar acción si aún no ha empezado
		if not action.is_running:
			action.start(entity, world)
		
		# actualizar acción
		action.update(entity, world, delta)
		
		# si termina → aplicar efectos y pasar a la siguiente
		if action.is_finished:
			
			var world_state : WorldStateComponent = world.get_component(entity, WorldStateComponent)
			var move : MovementComponent = world.get_component(entity, MovementComponent)
			
			# resetear world_state a valores por defecto
			world_state.state = {
				"has_target": false,
				"in_target_position": false,
				"at_target": false,
				"wander": false
			}
			
			# detener movimiento
			if move:
				move.direction = Vector2.ZERO
			
			# quitar acción del plan
			plan.pop_front()
			
			# reset interno por si se reutiliza
			action.reset()
