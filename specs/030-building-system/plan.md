# Plan

## Direction
- Keep building placement deterministic and debuggable (clear state machine, explicit cleanup).
- Treat `BuildOrderComponent` as the single source of truth for placement state.

## Improvements
- Avoid reallocating components every preview tick (cache the chosen type / footprint).
- Add bounds checks for the footprint against map dimensions.
- Consider reserving tiles during preview if multiple orders/players are ever added.

## Validation
- Manual: preview color changes, confirm places tiles, abort clears preview.
- Headless: `godot --headless --path . --quit`.
