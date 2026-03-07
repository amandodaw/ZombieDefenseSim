# AGENTS.md - ZombieDefenseSim Development Guide

## Project Overview
- Engine: Godot 4.6 (GL Compatibility renderer)
- Language: GDScript
- Architecture: Component-Entity-System (ECS) pattern
- Physics: Jolt Physics (3D) (not used by 2D gameplay scripts)

## Build, Run, Lint, Test

### Run the Game
```bash
# Run the project directly
godot --path .

# Open the editor
godot --editor
```

### Headless Validation (Closest to Tests)
```bash
# Load project/scripts without opening a window
godot --headless --path . --quit
```

### Linting
- No standard linter is configured.
- Use Godot's built-in script validation in the editor if needed.

### Tests
- There are no automated tests in this repository.
- There is no single-test command available.

## Code Style Guidelines

### File Organization
```
scripts/
├── components/    # ECS components (data + light logic)
├── systems/       # ECS systems (processors)
├── ui.gd          # UI logic
├── world.gd       # Main ECS manager
└── grid_utils.gd  # Utilities
```

### Naming Conventions
- Classes: PascalCase (e.g., GoapAction, BuildingSystem)
- Files: snake_case to match class name (e.g., goap_action.gd)
- Variables: snake_case (e.g., human_id, world_state)
- Constants: UPPER_SNAKE_CASE (e.g., TILE_SIZE)
- Private members: prefix with underscore (e.g., _next_entity_id)

### Types and Annotations
- Prefer explicit type hints for fields, parameters, and returns.
- Use typed arrays when feasible: Array[int], Array[GoapAction].
- Use := when the inferred type is obvious.
```gdscript
var player_id : int = 0
var position : Vector2i = Vector2i.ZERO
var plan : Array[GoapAction] = []
var result := []
```

### Imports and Script Registration
- Use class_name in scripts that act as ECS components/systems.
- Prefer preload for scenes/resources used at runtime.
```gdscript
class_name World
var human_scene : PackedScene = preload("res://scenes/human.tscn")
```

### Formatting
- 4-space indentation (Godot default).
- No trailing whitespace.
- One space after colon in type annotations: var name : String
- Keep lines readable; break long expressions.

### ECS Patterns

#### Component Registration
```gdscript
var components := {}  # type -> {entity -> component}
func add(entity: int, component) -> void:
    var type = component.get_script()
    if not components.has(type):
        components[type] = {}
    components[type][entity] = component
```

#### Query Pattern
```gdscript
func query(required_types: Array) -> Array:
    # Returns entities with ALL required component types
    pass
```

#### System Update Loop
```gdscript
func update(world: World, delta):
    for entity in world.query([ComponentA, ComponentB]):
        var comp_a : ComponentA = world.get_component(entity, ComponentA)
        # process entity
```

### Control Flow
- Use match for state machines when appropriate.
```gdscript
match build_order.state:
    BuildOrderComponent.State.ABORTED:
        world.destroy_entity(order_id)
    BuildOrderComponent.State.PENDING:
        if input.build_mode:
            build_order.state = BuildOrderComponent.State.PREVIEW
```

### Error Handling
- Use early returns for null checks and invalid states.
- Prefer explicit guards over implicit assumptions.
```gdscript
if workplace_pos == null:
    return
```

### Data Ownership
- Systems update components; avoid direct Node manipulation outside systems.
- Prefer PositionComponent as source of truth; SpriteComponent mirrors it.

## Godot-Specific Conventions

### Node References
```gdscript
@onready var camera = $PlayerCamera
@onready var map = $MapLayers
```

### Signals
- Connect signals once; avoid reconnecting inside repeated methods.
- Use Callable checks to prevent duplicate connections.

## Common Pitfalls in This Repo
- Preview/build logic should not add duplicate components per frame.
- UI signal hookups should not happen in methods called repeatedly.
- Avoid writing to PositionComponent and Sprite simultaneously in actions.
- Ensure destroyed entities are removed from spatial indexes.

## Important Files
- project.godot: project configuration
- scripts/world.gd: ECS manager, entity creation, query system
- scripts/systems/*.gd: game systems (GOAP, building, physics, etc.)
- scripts/components/*.gd: ECS components

## Git Conventions
- Use clear commit messages.
- Branch naming examples: feature/..., fix/..., work_action

## Cursor/Copilot Rules
- No .cursor/rules/, .cursorrules, or .github/copilot-instructions.md found.
