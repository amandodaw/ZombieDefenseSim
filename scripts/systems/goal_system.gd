class_name GoalSystem

func update(world: World, delta):

	for entity in world.query([
		GoalComponent,
		WorldStateComponent,
		PlanComponent
	]):

		var goal_component = world.get_component(entity, GoalComponent)
		var world_state : WorldStateComponent = world.get_component(entity, WorldStateComponent)
		var plan_component : PlanComponent = world.get_component(entity, PlanComponent)
		var worker_comp : WorkerComponent = world.get_component(entity, WorkerComponent)
		var move : MovementComponent = world.get_component(entity, MovementComponent)
		
		#if worker_comp.workplace != worker_comp.last_workplace:
			#invalidate_plan(entity, world)
			#worker_comp.last_workplace = worker_comp.workplace
		#var current_action = plan_component.plan.front()
		#if current_action:
			#if not are_preconditions_valid(current_action, world_state):
				#print("Plan invalidado")
				#plan_component.plan.clear()
		if not plan_component.plan.is_empty():
			continue
		# reset goals
		for key in goal_component.goals.keys():
			goal_component.goals[key] = false
		if worker_comp.workplace == -1:
			world_state.state["at_target"] = false
			world_state.state["has_target"] = false
			world_state.target_pos = Vector2i.ZERO
			move.direction = Vector2i.ZERO

		if worker_comp.workplace != -1:
			world_state.target_pos = world.get_component(worker_comp.workplace, PositionComponent).value
			world_state.state["has_target"] = true
			world_state.state["at_target"] = false
			goal_component.goals["enough_resources"] = true


func invalidate_plan(entity, world):
	var plan = world.get_component(entity, PlanComponent)
	if plan:
		plan.plan.clear()

func are_preconditions_valid(action, world_state):

	for key in action.preconditions.keys():
		if world_state.state.get(key) != action.preconditions[key]:
			return false

	return true
