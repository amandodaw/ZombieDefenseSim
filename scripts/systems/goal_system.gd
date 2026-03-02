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

		if not plan_component.plan.is_empty():
			continue

		# reset goals
		for key in goal_component.goals.keys():
			goal_component.goals[key] = false

		var state = world_state.state

		# Si tiene target pero no ha llegado → querer estar en el target
		if state.get("has_target", false) and not state.get("at_target", false):
			goal_component.goals["at_target"] = true
			continue

		# Si no tiene target → conseguir uno
		if not state.get("has_target", false):
			goal_component.goals["has_target"] = true
			continue
