# Wander Fallback Action

## Intent
Provide a deterministic, always-available fallback action so an agent never stalls when no other goals/actions are applicable.

## Problem
When the planner cannot produce a meaningful plan (no valid goals, no satisfiable actions, or plan cost is effectively infinite), agents can end up doing nothing indefinitely.

## Requirements
- A new GOAP/AI action named `Wander` (or `WanderFallback`) exists.
- The action is eligible when there is nothing more important to do.
- The action results in the agent moving to a nearby reachable location.
- The action must be safe:
  - Do not move outside map bounds.
  - Do not pick blocked/invalid tiles.
  - Do not interrupt higher-priority work once it becomes available.
- The action must be cheap and cancellable.

## Trigger / Selection Rules
- The fallback is selected when the planner fails to build a plan for the current tick/replan cycle.
- Alternatively, if the system supports explicit goal priorities, `Wander` is a lowest-priority goal/action that is always satisfiable.

## Action Behavior
- Choose a destination within a small radius around the agent (configurable).
- Prefer destinations that are:
  - reachable (path exists)
  - not currently occupied if occupancy exists
  - not identical to current position
- If no valid destination exists, the action completes immediately with no movement.

## Completion
- Succeeds when the agent reaches the destination, or after a short timeout if movement cannot progress.
- Always leaves the world state valid; no permanent reservations/locks.

## Acceptance Criteria
- If an agent has no valid plan, it eventually starts moving around instead of idling.
- If a real task becomes available (e.g., work, combat, hauling), the agent stops wandering and switches to the new plan on the next replan.
- Wander never causes errors or out-of-bounds/pathing assertions.

## Non-Goals
- No "smart" exploration, scouting, or threat avoidance (unless already supported by existing systems).
- No new UI.
