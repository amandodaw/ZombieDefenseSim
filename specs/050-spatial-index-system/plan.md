# Plan

## Direction
- Treat the spatial index as a shared service for perception, pathing, and occupancy checks.

## Improvements
- Integrate entity destruction so stale entries cannot remain in `tile_entities`.
- Consider indexing only entities with both `PositionComponent` and a marker component (if needed for performance).
- Add optional bounds validation for tiles.

## Validation
- Manual: move an entity and verify tile membership changes.
- Headless: `godot --headless --path . --quit`.
