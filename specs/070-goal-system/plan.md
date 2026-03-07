# Plan

## Direction
- Keep goal selection separate from planning and execution.

## Improvements
- Add goal priorities (explicit ordering) instead of relying on dictionary iteration.
- Make goal computation independent from current plan (or define strict rules for when goals can change).
- Expand world state keys to support more complex goals (combat, hunger, hauling).

## Validation
- Manual: assigning/unassigning workplace flips between goals and triggers replanning.
- Headless: `godot --headless --path . --quit`.
