class_name GoalSystem

func update(world: World, delta):

	for entity in world.query([
		GoalComponent,
		WorldStateComponent,
		PlanComponent
	]):

		var goal_component = world.get_component(entity, GoalComponent)
		var world_state = world.get_component(entity, WorldStateComponent)
		var plan_component = world.get_component(entity, PlanComponent)
		var worker_comp : WorkerComponent = world.get_component(entity, WorkerComponent)
		var move : MovementComponent = world.get_component(entity, MovementComponent)

		if not plan_component.plan.is_empty():
			continue

		# reset goals
		for key in goal_component.goals.keys():
			goal_component.goals[key] = false

		var state = world_state.state
		# limpiar estado si no tiene workplace
		if worker_comp.workplace == -1:
			state["has_target"] = false
			state["at_target"] = false
			continue
		# Si tiene trabajo asignado, trabajar
		if worker_comp.workplace !=-1:
			var workplace_pos = world.get_component(worker_comp.workplace, PositionComponent)
			move.target = workplace_pos.value
			state["has_target"] = true
			state["at_target"] = false
			goal_component.goals["enough_resources"] = true
			continue
			
		# Si tiene target pero no ha llegado → querer estar en el target
		if state.get("has_target", false) and not state.get("at_target", false):
			goal_component.goals["at_target"] = true
			continue

		# Si no tiene target → conseguir uno
		if not state.get("has_target", false):
			goal_component.goals["has_target"] = true
			continue
