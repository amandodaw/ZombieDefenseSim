# GOAP System (Planner)

## Intent
Build an action plan that satisfies the current active goal, chaining actions via preconditions and effects.

## Responsibilities
- When an entity has active goals and an empty plan, build a plan using available actions.
- Implement a basic GOAP planner over `WorldStateComponent.state` and `GoalComponent.goals`.

## Reads
- `GoalComponent.goals` (active goal flags).
- `WorldStateComponent.state` (planner state).
- `PlanComponent.plan` (must be empty to plan).
- `ActionComponent.get_actions()` (available `GoapAction` instances).

## Writes / Side Effects
- Appends a computed sequence of `GoapAction` objects into `PlanComponent.plan`.

## Planning Algorithm (Current)
- Breadth-first search over discrete world states.
- Node = `{ state: Dictionary, plan: Array }`.
- Expansion: for each action whose `preconditions` are satisfied, apply `effects` to a duplicated state and enqueue.
- Termination: first node that satisfies the goal conditions returns its plan.
- Visited: skip already-seen states via dictionary equality.

## Notes / Risks
- No costs, no heuristics, and no depth/iteration limit; add safety guards if action sets grow.
- Goals are taken as the first active goal in dictionary iteration order.
- Each planning attempt instantiates new action objects via `ActionComponent`.

## References
- `scripts/systems/goap_system.gd`
- `scripts/components/action_component.gd`
- `scripts/components/goap_action.gd`
- `scripts/components/plan_component.gd`
- `scripts/components/world_state_component.gd`
