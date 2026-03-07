# Plan

## Direction
- Keep `InputSystem` as a thin translator: Godot input -> ECS intents.
- Centralize input flags in `InputComponent` and avoid direct calls except for explicit actions (e.g. spawning).

## Improvements
- Remove debug prints or guard them behind a debug setting.
- Split one-shot intents (`confirm_order`, `abort_order`) from persistent modes (`build_mode`, `spawn_human`).
- Consider debouncing/timing rules for clicks when UI is open.

## Validation
- Manual: click interactions in-game for build/spawn and UI toggle.
- Headless: `godot --headless --path . --quit` (script load validation).
