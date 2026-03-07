# Plan

## Direction
- Keep `CityComponent` as the authoritative aggregate state for the simulation.

## Improvements
- Add explicit fields for resources (e.g. food, wood, stone) and their producers/consumers.
- Add consistent registration/unregistration hooks for humans/buildings (including when entities are destroyed).
- Replace `get(0)` with a stable `world.city_id` or store city id in `World`.

## Validation
- Manual: spawning humans adds them to the city list.
- Headless: `godot --headless --path . --quit`.
