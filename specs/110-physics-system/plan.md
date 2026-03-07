# Plan

## Direction
- Keep ECS as the source of intent (direction/speed) and nodes as the rendered result.

## Improvements
- Decide on a single coordinate type for positions (Vector2 vs Vector2i) and enforce it consistently.
- Add collision/pathing integration later (if needed).
- Avoid double-writing position in actions (some actions currently also change `PositionComponent.value`).

## Validation
- Manual: moving entities should update both sprite and ECS position.
- Headless: `godot --headless --path . --quit`.
