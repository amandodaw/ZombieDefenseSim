# Plan

## Direction
- Keep the planner deterministic and safe (bounded work per tick).

## Improvements
- Add action costs and choose lowest-cost plan.
- Add iteration/depth limits with a fallback (e.g. wander).
- Cache action instances per entity if actions are stateless, or define action factories clearly.

## Validation
- Manual: with goals set, entities should generate a plan and execute it.
- Headless: `godot --headless --path . --quit`.
