class_name GoapSystem


func update(world: World, delta):
	for entity in world.query([
		GoalComponent,
		WorldStateComponent,
		PlanComponent,
		ActionComponent
	]):
		
		var goal_component : GoalComponent = world.get_component(entity, GoalComponent)
		var world_state_component : WorldStateComponent = world.get_component(entity, WorldStateComponent)
		var goals : Dictionary = goal_component.goals
		var plan : Array[GoapAction] = world.get_component(entity, PlanComponent).plan
		var action_component : ActionComponent = world.get_component(entity, ActionComponent)
		var actions : Array[GoapAction] = action_component.get_actions()
		
		if not plan.is_empty():
			continue
		
		# No planificar si no hay goals activos
		var has_active_goal := false
		for key in goals.keys():
			if goals[key]:
				has_active_goal = true
				break
		if not has_active_goal:
			continue
		# planificar para el primer goal activo
		for goal_key in goals.keys():
			if not goals[goal_key]:
				continue
			
			var goal_dict := { goal_key: goals[goal_key] }
			var new_plan = build_plan(
				world_state_component.state,
				goal_dict,
				actions
			)
			
			if new_plan.size() > 0:
				plan.append_array(new_plan)
				break
			
		
# =========================================================
# ===================== PLANNER GOAP ======================
# =========================================================

func build_plan(start_state: Dictionary, goal: Dictionary, actions: Array[GoapAction]) -> Array:
	
	var queue := []
	var visited := []
	
	queue.append({
		"state": start_state.duplicate(true),
		"plan": []
	})
	
	while queue.size() > 0:
		
		var node = queue.pop_front()
		var state : Dictionary = node["state"]
		var current_plan : Array = node["plan"]
		
		# ¿goal alcanzado?
		if satisfies(state, goal):
			return current_plan
		
		# evitar repetir estados ya visitados
		if is_state_visited(state, visited):
			continue
		
		visited.append(state)
		
		# probar acciones posibles
		for action in actions:
			
			if not satisfies(state, action.preconditions):
				continue
			
			var new_state = state.duplicate(true)
			apply_effects(new_state, action.effects)
			
			var new_plan = current_plan.duplicate()
			new_plan.append(action)
			
			queue.append({
				"state": new_state,
				"plan": new_plan
			})
	
	return []



# =========================================================
# =================== FUNCIONES HELPER ====================
# =========================================================

func satisfies(state: Dictionary, conditions: Dictionary) -> bool:
	for key in conditions:
		if not state.has(key):
			return false
		if state[key] != conditions[key]:
			return false
	return true


func apply_effects(state: Dictionary, effects: Dictionary):
	for key in effects:
		state[key] = effects[key]


func is_state_visited(state: Dictionary, visited: Array) -> bool:
	for v in visited:
		if v == state:
			return true
	return false
