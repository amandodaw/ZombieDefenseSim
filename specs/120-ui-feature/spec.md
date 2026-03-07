# UI Feature (Menu)

## Intent
Provide an in-game UI menu that is normally hidden and can be expanded ("desplegable") to inspect and manage the city.

## Scope
This is a feature, not an ECS system.

## Menu Structure (Target)
- A collapsible drawer/panel that is hidden by default.
- When expanded, it shows multiple sections (now only "unit control" exists):
  - Unit control: list humans in the city, show current assignment, allow reassignment.
  - Buildings: list buildings/workplaces in the city.
  - City resources: show available resources (not implemented yet in city data).

## Current Implementation (What Exists Today)
- Scene: `scenes/ui.tscn` has `UI (CanvasLayer)` -> `Control` with:
  - `BuildMenu (VBoxContainer)` (buttons for build/spawn actions)
  - `WorkMenu (VBoxContainer)` (unit assignment UI)
- Script: `scripts/ui.gd`
  - Creates build buttons from `InputComponent.Buildings`.
  - Updates worker assignment UI based on `CityComponent.humans` and `CityComponent.buildings`.
  - Assigns a worker to a workplace via `OptionButton` and sets `WorkerComponent.workplace`.
  - Marks `WorldStateComponent.state["state_dirty"] = true` to trigger replanning.
- Menu visibility is currently toggled by input (`build_menu` action) in `InputSystem` via `world.ui.visible = !world.ui.visible`.

## Requirements
- The menu is hidden inside a collapsible UI (drawer/panel) and only shows its content when the player expands it.
- The expanded view shows:
  - Humans in the city
  - Buildings/workplaces in the city
  - For each human, the current workplace assignment
  - A clean way to reassign a human to another workplace (already implemented but currently toscamente).

## Data Sources
- `CityComponent.humans : Array` (entity ids)
- `CityComponent.buildings : Array` (entity ids)
- `WorkerComponent.workplace : int` on each human
- `WorkplaceComponent.name : String` on each building/workplace

## User Interactions
- Expand/collapse the drawer.
- Per-human assignment change via a dropdown (OptionButton) or equivalent.
- Optional: toggle build/spawn actions (currently in `BuildMenu`).

## Notes / Risks
- `scripts/ui.gd` currently calls `world.connect(...)` inside `actualizar_menu()`, which can lead to duplicate connections if called multiple times.
- UI rebuild is done by deleting and recreating children; acceptable short-term, but should be structured to avoid flicker and repeated allocations.
- City lookup assumes `world.player_id` has `CityComponent`.

## References
- `scenes/ui.tscn`
- `scripts/ui.gd`
- `scripts/systems/input_system.gd`
- `scripts/components/city_component.gd`
- `scripts/components/worker_component.gd`
- `scripts/components/workplace_component.gd`
