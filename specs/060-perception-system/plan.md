# Plan

## Direction
- Keep perception deterministic and decoupled: it only writes what is visible, other systems decide what to do.

## Improvements
- Add optional distance filtering (avoid corners outside intended range).
- Add basic occlusion/LOS only if needed later.
- Ensure `VisionComponent.randomize_timer()` is called on spawn to stagger updates.

## Validation
- Manual: move entities and verify `visible_entities` changes.
- Headless: `godot --headless --path . --quit`.
