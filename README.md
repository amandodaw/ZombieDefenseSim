# ZombieDefenseSim

Welcome to **ZombieDefenseSim**, a strategic zombie survival game built with [Godot Engine 4.6](https://godotengine.org/). 

This project utilizes a custom **Component-Entity-System (ECS)** architecture integrated directly into Godot using **GDScript**, ensuring modular, performant, and decoupled data-driven gameplay.

## 🌟 Core Features

- **ECS Architecture**: Custom built Entity-Component-System framework for handling game logic efficiently.
- **Goal-Oriented Action Planning (GOAP)**: Advanced AI system for intelligent and dynamic non-player character behaviors.
- **Physics**: Integrated with **Jolt Physics (3D)** for robust physics interactions.
- **Rendering**: Optimized using the GL Compatibility renderer.

## 📂 Project Structure

```text
ZombieDefenseSim/
├── docs/             # Project documentation
├── resources/        # Game resources, preloads, and data files
├── scenes/           # Godot scenes (.tscn)
└── scripts/          # GDScript source code
    ├── components/   # ECS Data components
    ├── systems/      # ECS Logic processors (building, GOAP, physics, etc.)
    ├── ui.gd         # Centralized UI logic
    ├── world.gd      # Main ECS manager and query system
    └── grid_utils.gd # Grid and spatial utilities
```

## 🛠️ Setup and Running

You can load and play the game directly using the Godot Engine editor or run it from the command line:

```bash
# Run the project directly
godot --path .

# Open the editor
godot --editor

# Run headless validation (no window)
godot --headless --path . --quit
```

*(Note: No automated tests are configured out-of-the-box for this repo.)*

## 💻 Architecture Details

The project fundamentally relies on resolving game logic through components and systems rather than deep node inheritance:

1. **Components**: Pure data buckets with minimal light logic. Located in `scripts/components/`.
2. **Systems**: Independent processors that query entities with specific components to perform updates. Located in `scripts/systems/`.
3. **WorldManager (`world.gd`)**: The heart of the ECS, handling entity creation, component registration, and system updates.

### GOAP (Goal-Oriented Action Planning)
The AI in the game uses a dynamic GOAP implementation. Actions and goals are evaluated dynamically, allowing NPCs (like humans or zombies) to chain actions intelligently based on the current world state.

## 🤝 Contributing & Style Guide

When contributing to the codebase, please adhere to the following GDScript conventions:

- Use **explicit type hints** (e.g., `var player_id : int = 0`).
- Group logic into Component definitions (`PascalCase`) and process them within generic Systems.
- Follow the 4-space indentation standard of Godot.
- File names should match class names but in `snake_case` (e.g., `goap_action.gd` for `GoapAction`).
- Handle errors with early returns rather than deep nesting.

For a deeper dive into code principles, please refer to the `AGENTS.md` guidelines provided within the repository.
