class_name ReplanSystem

func update(world: World, delta):

	for entity in world.query([
		PlanComponent,
		WorldStateComponent
	]):

		var plan_component : PlanComponent = world.get_component(entity, PlanComponent)
		var world_state : WorldStateComponent = world.get_component(entity, WorldStateComponent)

		if plan_component.plan.is_empty():
			continue

		var current_action = plan_component.plan.front()

		if world_state.state["state_dirty"]:
			world_state.state["state_dirty"] = false
			print("Plan invalidado")
			plan_component.plan.clear()
