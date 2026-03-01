class_name GoapExecutionSystem


func update(world: World, delta):

	for entity in world.query([
		PlanComponent,
		WorldStateComponent
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
			
			# aplicar efectos al mundo real
			for key in action.effects:
				world_state.state[key] = action.effects[key]
			
			# quitar acción del plan
			plan.pop_front()
			
			# reset interno por si se reutiliza
			action.reset()
