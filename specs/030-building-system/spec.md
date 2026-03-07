# Building System

## Intent
Drive the building placement flow: preview -> validate -> confirm -> spawn/place building.

## Responsibilities
- Process `BuildOrderComponent` entities as state machines.
- Render placement previews in `world.preview_map`.
- Validate placement against the building tilemap.
- On confirmation, place tiles and register the building in the city.

## Reads
- `BuildOrderComponent`: `type`, `state`, `valid_pos`.
- Player `InputComponent`: `build_mode`, `confirm_order`, `abort_order`.
- `PositionComponent` on the build-order entity.
- `world.map_layer`, `world.building_map`, `world.preview_map`.

## Writes / Side Effects
- Mutates `BuildOrderComponent.state` and `BuildOrderComponent.valid_pos`.
- Writes preview tiles into `world.preview_map` and clears it on transitions.
- Writes final building tiles into `world.building_map`.
- Adds workplace/building components onto the same entity (`WorkplaceComponent` + type component).
- Removes `BuildOrderComponent` after placement.
- Appends the building entity id to `CityComponent.buildings`.
- Emits `world.building_created`.

## Update Algorithm (High-Level)
For each entity with `BuildOrderComponent`:
1. `PENDING`: if `input.build_mode` -> `PREVIEW`.
2. `PREVIEW`:
   - Update cursor position and draw preview.
   - Validate footprint vs occupied building tiles.
   - If confirm and valid -> `CONFIRMED`.
   - If abort -> `ABORTED`.
3. `CONFIRMED`: place tiles, finalize components, clear preview, exit build mode.
4. `ABORTED`: cleanup, clear preview, reset input flags, destroy order entity.

## Notes / Risks
- The order entity becomes the building entity (components are attached to the same id).
- `preview_building()` creates type components every tick; `world.add()` overwrites by script type, but it is still work done per frame.
- Validation currently checks only the `world.building_map` occupancy (tile source id != -1).

## References
- `scripts/systems/building_system.gd`
- `scripts/components/build_order_component.gd`
- `scripts/components/workplace_component.gd`
- `scripts/components/farm_component.gd`
- `scripts/components/kitchen_component.gd`
- `scripts/components/house_component.gd`
- `scripts/world.gd`
