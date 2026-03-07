# Physics System

## Intent
Move the Godot nodes that represent ECS entities, based on ECS movement state.

## Responsibilities
- Apply `MovementComponent` direction and speed to `Sprite2D` node positions.
- Mirror the resulting node position back into `PositionComponent`.

## Reads
- `MovementComponent.direction`, `MovementComponent.speed`.
- `SpriteComponent.sprite` (node reference).

## Writes / Side Effects
- Updates `sprite.global_position`.
- Writes back to `PositionComponent.value`.

## Update Algorithm (High-Level)
For each entity with `MovementComponent`, `SpriteComponent`, `PositionComponent`:
1. Normalize movement direction if non-zero.
2. Compute velocity = direction * speed.
3. Move sprite by `velocity * delta`.
4. Copy sprite global position into `PositionComponent.value`.

## Notes / Risks
- `PositionComponent.value` is currently typed as `Vector2i`, while `sprite.global_position` is `Vector2`.
- This system should run after any system that sets `MovementComponent.direction`.

## References
- `scripts/systems/physics_system.gd`
- `scripts/components/movement_component.gd`
- `scripts/components/sprite_component.gd`
- `scripts/components/position_component.gd`
