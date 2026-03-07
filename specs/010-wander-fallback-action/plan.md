# Plan

## Where This Fits
- GOAP planning: ensure there is always at least one executable behavior.
- Execution: `Wander` behaves like any other action and can be interrupted by replanning.

## Implementation Outline
1. Add a new action definition for wandering (name, preconditions, effects, cost).
2. Update the planner/replanner so that when no plan is found it selects `Wander`.
3. Add destination selection logic:
   - sample candidate tiles around the current position
   - filter invalid/blocked/unreachable candidates
   - pick one deterministically (seeded) or randomly
4. Ensure movement uses the existing movement/pathing system (no direct Node manipulation).
5. Add cancellation rules:
   - if a new plan is produced, stop wandering cleanly
   - clear any temporary reservations
6. Add debug hooks/logging only if needed to verify selection and execution.

## Config
- `wander_radius_tiles` (default small, e.g. 6)
- `wander_timeout_seconds` (default short, e.g. 3-8)

## Risks / Edge Cases
- Very small maps or fully blocked areas: must complete without moving.
- High replanning frequency: avoid thrashing between wander targets.
- Multiple agents: avoid clustering if occupancy/reservations exist.
