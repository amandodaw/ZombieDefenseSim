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
			var goal_component : GoalComponent = world.get_component(entity, GoalComponent)
			var move : MovementComponent = world.get_component(entity, MovementComponent)
			
			# aplicar efectos al mundo real
			for key in action.effects:
				world_state.state[key] = action.effects[key]
			
			# marcar goals completados
			if goal_component:
				for key in action.effects:
					if goal_component.goals.has(key):
						goal_component.goals[key] = false
			
			# detener movimiento
			if move:
				move.direction = Vector2.ZERO
			
			# quitar acción del plan
			plan.pop_front()
			
			# reset interno por si se reutiliza
			action.reset()
