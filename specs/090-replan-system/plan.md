# Plan

## Direction
- Keep replanning triggers explicit and minimal.

## Improvements
- Track what changed (reason codes) to avoid unnecessary replans.
- Add cooldown to avoid thrashing when state toggles rapidly.
- Remove debug prints or route them through a debug utility.

## Validation
- Manual: changing workplace sets `state_dirty` and clears the plan.
- Headless: `godot --headless --path . --quit`.
