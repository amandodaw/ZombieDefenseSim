# City System

## Intent
Maintain city-level bookkeeping: which humans exist and which workplaces/buildings exist (and later, available resources).

## Responsibilities
- Ensure every `HumanComponent` entity is registered in the active `CityComponent`.
- Act as the logical place for city resources and other aggregate state (not implemented yet).

## Reads
- `HumanComponent` presence on entities.
- The first entity with `CityComponent` (current implementation assumes a single city).

## Writes / Side Effects
- Appends missing humans into `CityComponent.humans`.

## Update Algorithm (High-Level)
1. Resolve the city entity id via `world.query([CityComponent]).get(0)`.
2. For each entity with `HumanComponent`, add it to `city.humans` if not present.

## Notes / Risks
- Assumes exactly one city exists and it is always queryable.
- Resources and workplace registries are expected here but are currently managed elsewhere (e.g. buildings appended in `BuildingSystem`).

## References
- `scripts/systems/city_system.gd`
- `scripts/components/city_component.gd`
- `scripts/components/human_component.gd`
- `scripts/world.gd`
