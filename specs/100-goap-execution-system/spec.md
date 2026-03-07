# GOAP Execution System

## Intent
Execute the current GOAP plan by running the first action until it finishes, then moving to the next.

## Responsibilities
- Start actions when they become active.
- Tick the running action every frame.
- On completion, apply action effects and advance the plan.

## Reads
- `PlanComponent.plan`.
- `GoapAction` runtime flags: `is_running`, `is_finished`.
- `MovementComponent` (to stop movement on action completion).

## Writes / Side Effects
- Calls `action.start(entity, world)` once per action.
- Calls `action.update(entity, world, delta)` every tick.
- On finish:
  - Calls `action.apply_effects_to_world(world, entity)`.
  - Stops movement (`move.direction = Vector2.ZERO`).
  - Pops the action from the plan.
  - Calls `action.reset()`.

## Update Algorithm (High-Level)
For each entity with a non-empty plan:
1. Take the first action.
2. If not running: start.
3. Update.
4. If finished: apply effects, stop movement, pop action, reset.

## Notes / Risks
- Actions are objects stored in the plan array; ensure they are not shared across entities.
- Effects are applied to `WorldStateComponent.state` via `GoapAction.apply_effects_to_world()`.

## References
- `scripts/systems/goap_execution_system.gd`
- `scripts/components/goap_action.gd`
- `scripts/components/plan_component.gd`
