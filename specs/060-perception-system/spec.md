# Perception System

## Intent
Populate each entity's perceived/visible entities using the spatial index.

## Responsibilities
- Periodically update `VisionComponent.visible_entities` for entities that have vision.
- Query `SpatialIndexSystem` for entities present in nearby tiles.

## Reads
- `PositionComponent` for the observer.
- `VisionComponent`: `range`, `update_interval`, `time_until_update`.
- `SpatialIndexSystem.tile_entities`.

## Writes / Side Effects
- Decrements and resets `VisionComponent.time_until_update`.
- Clears and fills `VisionComponent.visible_entities`.

## Update Algorithm (High-Level)
For each entity with `PositionComponent` and `VisionComponent`:
1. Tick down `time_until_update`.
2. If still positive, skip.
3. Reset timer to `update_interval`.
4. Convert world position to tile, iterate a square of tiles with radius `range`.
5. Append all entities found in those tiles except self.

## Notes / Risks
- This is a tile-square scan, not line-of-sight and not a circular radius.
- No filtering by component type is done here; consumers can filter later.
- Depends on `SpatialIndexSystem` being updated before perception in the `World` system order.

## References
- `scripts/systems/perception_system.gd`
- `scripts/systems/spatial_index_system.gd`
- `scripts/components/vision_component.gd`
- `scripts/components/position_component.gd`
