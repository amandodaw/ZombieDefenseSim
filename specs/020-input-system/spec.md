# Input System

## Intent
Handle player input and translate it into ECS state changes (components/flags) and world actions.

## Responsibilities
- Read Godot input actions and update `InputComponent` on the player entity.
- Trigger immediate world actions that are input-driven (e.g. spawn a human).
- Toggle UI visibility via `world.ui`.

## Reads
- `InputComponent` (player): `build_mode`, `spawn_human`, `abort_order`.
- Godot actions: `left_click`, `right_click`, `build_menu`.
- `world.camera`, `world.map_layer`, `world.ui`.

## Writes / Side Effects
- `InputComponent.confirm_order` set on left click while in build mode.
- `InputComponent.abort_order` + `InputComponent.build_mode` changes on right click.
- `InputComponent.spawn_human` cleared on right click.
- Calls `world.create_human(world.get_global_mouse_position())`.
- Toggles `world.ui.visible`.

## Update Algorithm (High-Level)
1. Fetch player `InputComponent`.
2. On `left_click`:
   - If `build_mode`: set `confirm_order = true` (and debug-print mouse tile).
   - If `spawn_human`: spawn human at mouse position.
3. On `right_click`:
   - If `build_mode`: set `build_mode = false` and `abort_order = true`.
   - If `spawn_human`: set `spawn_human = false`.
4. On `build_menu`: toggle UI visibility.

## Notes / Risks
- The system currently prints to stdout; consider gating behind a debug flag.
- Input is applied directly to ECS components; other systems consume these flags.

## References
- `scripts/systems/input_system.gd`
- `scripts/components/input_component.gd`
- `scripts/world.gd`
