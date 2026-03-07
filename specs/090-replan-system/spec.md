# Replan System

## Intent
Invalidate an agent's current plan when a key part of the world state changes, so it can be replanned.

## Responsibilities
- Detect `WorldStateComponent.state["state_dirty"]` and clear `PlanComponent.plan`.

## Reads
- `PlanComponent.plan`.
- `WorldStateComponent.state["state_dirty"]`.

## Writes / Side Effects
- Sets `state_dirty` back to false.
- Clears `plan_component.plan`.
- Prints a debug line ("Plan invalidado").

## Update Algorithm (High-Level)
For each entity with `PlanComponent` and `WorldStateComponent`:
1. If plan is empty: skip.
2. If `state_dirty` is true: clear plan and reset the flag.

## Notes / Risks
- This system only invalidates; it does not trigger planning directly (planner runs later in the system order).
- Consider removing or guarding prints.

## References
- `scripts/systems/replan_system.gd`
- `scripts/components/world_state_component.gd`
- `scripts/components/plan_component.gd`
