# Plan

## Direction
- Keep execution simple: one action at a time, explicit start/update/finish lifecycle.

## Improvements
- Add action failure handling (fail -> clear plan or replan).
- Add optional per-action debug tracing.
- Define how interruptions should work when `ReplanSystem` clears the plan mid-action.

## Validation
- Manual: observe agents progressing through `GoToAction` -> `WorkAction` etc.
- Headless: `godot --headless --path . --quit`.
