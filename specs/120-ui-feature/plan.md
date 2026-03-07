# Plan

## Drawer UI
- Add a dedicated drawer root node (e.g. `PanelContainer`) with:
  - a header button (always visible) to expand/collapse
  - a content container that is shown/hidden
- Keep the existing hotkey toggle as a shortcut, but ensure the drawer UX works by mouse.

## Sections
- Split the UI into sections/nodes:
  - Unit control (workers + assignments)
  - Buildings list
  - Resources (placeholder until implemented)

## Data Refresh
- Connect world signals once in `_ready()` (guard against duplicates).
- Refresh only the affected section when possible (e.g. worker list on human/building created).

## Assignment UX
- For each worker row:
  - show worker id (later: name)
  - show current workplace ("Ninguno" when -1)
  - dropdown to change assignment
- On assignment:
  - set `WorkerComponent.workplace`
  - set `WorldStateComponent.state["state_dirty"] = true`

## Validation
- Manual: expand/collapse works; reassignment updates GOAP behavior.
- Headless load validation: `godot --headless --path . --quit`.
