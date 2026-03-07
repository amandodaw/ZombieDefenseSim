# Spatial Index System

## Intent
Maintain a fast spatial index mapping tiles to entities (and entities to their current tile) for perception and queries.

## Responsibilities
- Track `PositionComponent` entities and keep `tile_entities` / `entity_tiles` up to date.
- Provide helper queries for entities in a tile or in a range.

## Reads
- `PositionComponent.value` (world position) and converts it to tile coordinates via `GridUtils.world_to_tile()`.

## Writes / Side Effects
- `tile_entities : Dictionary` mapping `Vector2i(tile)` -> `Array[entity_id]`.
- `entity_tiles : Dictionary` mapping `entity_id` -> `Vector2i(tile)`.

## Update Algorithm (High-Level)
For each entity with `PositionComponent`:
1. Compute current tile from world position.
2. Compare against `entity_tiles[entity]` (previous tile).
3. If changed: remove from previous tile list and add to new tile list.

## Public Helpers
- `get_entities_in_tile(tile: Vector2i) -> Array`
- `get_entities_in_range(center: Vector2i, range_value: int) -> Array`
- `is_tile_occupied(tile: Vector2i) -> bool`
- `filter_entities_with_component(world, entities, component_type) -> Array`
- `is_tile_blocked_by_building(world, spatial, tile) -> bool`
- `get_visible_of_type(world, vision: VisionComponent, component_type) -> Array`

## Notes / Risks
- `remove_entity(entity)` must be called when an entity is destroyed; `World.destroy_entity()` does not currently notify the spatial index.
- The index is tile-based; any system expecting continuous positions must convert consistently.

## References
- `scripts/systems/spatial_index_system.gd`
- `scripts/grid_utils.gd`
- `scripts/components/position_component.gd`
