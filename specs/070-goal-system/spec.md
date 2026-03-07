# Goal System

## Intent
Compute and activate the current goal(s) for each human/agent based on its situation (e.g. assigned workplace).

## Responsibilities
- Decide which goal flags in `GoalComponent.goals` are active.
- Keep `WorldStateComponent` consistent with goal selection.
- Invalidate plans when the agent's workplace changes.

## Reads
- `WorkerComponent`: `workplace`, `last_workplace`.
- `PlanComponent.plan`.
- `WorldStateComponent.state` and `WorldStateComponent.target_pos`.
- `MovementComponent.direction`.
- `PositionComponent` of the workplace entity (when assigned).

## Writes / Side Effects
- Clears current plan when workplace changes.
- Resets all goal flags each tick when replanning is allowed.
- Sets goal `wander` when the agent has no workplace.
- Sets goal `enough_resources` and target position when workplace is assigned.
- Updates `WorldStateComponent.state` keys: `has_target`, `at_target`, `wander`, `enough_resources`.
- Stops movement when switching to wandering (current implementation sets `move.direction = Vector2.ZERO`).

## Update Algorithm (High-Level)
For each entity with required components:
1. If workplace changed: clear plan and update `last_workplace`.
2. If plan is not empty: skip goal recomputation.
3. Reset all `GoalComponent.goals` to false.
4. If `workplace == -1`:
   - Clear target-related world state; activate `wander` goal.
5. Else:
   - Set `target_pos` to workplace position; activate `enough_resources` goal.

## Notes / Risks
- Goals are currently boolean flags; there is no explicit priority system besides key iteration order.
- `invalidate_plan()` is exposed and used by UI when unassigning a worker.

## References
- `scripts/systems/goal_system.gd`
- `scripts/components/goal_component.gd`
- `scripts/components/world_state_component.gd`
- `scripts/components/worker_component.gd`
- `scripts/world.gd`
