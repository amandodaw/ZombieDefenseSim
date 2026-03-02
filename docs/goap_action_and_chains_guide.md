# GOAP Development Guides

## Guide 1 --- How to Implement a New Action

### Core Mental Model

A GOAP action is simply a way to change the world state.

    current state + action → new state

The planner connects states automatically.\
You only define how the world changes.

------------------------------------------------------------------------

### Step-by-Step Checklist

#### 1. Define the Effects (What changes in the world?)

This is the most important step.

Examples: - pick up food → `has_food = true` - eat → `hungry = false` -
sleep → `rested = true` - arrive at destination → `at_target = true`

Effects are what the planner wants to achieve.

------------------------------------------------------------------------

#### 2. Define Preconditions (When can the action run?)

What must already be true before the action is possible.

Examples: - eat requires: - `has_food = true` - `hungry = true` - sleep
requires: - `tired = true` - `at_bed = true`

------------------------------------------------------------------------

#### 3. Create the Action Class

Basic template:

``` gdscript
class_name EatAction
extends GoapAction

func _init():
    name = "Eat"

    preconditions = {
        "has_food": true,
        "hungry": true
    }

    effects = {
        "has_food": false,
        "hungry": false
    }
```

------------------------------------------------------------------------

#### 4. Implement Physical Execution (if needed)

Only if the action takes time or requires movement.

Use: - `start()` - `update()` - `finish()`

Instant action example:

``` gdscript
func start(entity, world):
    super.start(entity, world)
    finish()
```

------------------------------------------------------------------------

#### 5. Register the Action

Register the action type (not an instance).

``` gdscript
var action_types = [
    WanderAction,
    GoToAction,
    EatAction
]
```

------------------------------------------------------------------------

#### 6. Ensure World State Supports It

If new concepts are introduced, world state must represent them.

Example:

    hungry
    has_food
    tired
    at_bed

------------------------------------------------------------------------

#### 7. Ensure the Goal System Can Desire It

The planner only acts if a goal requests the state.

Example:

``` gdscript
if state["hungry"]:
    goal["hungry"] = false
```

------------------------------------------------------------------------

### Golden Rules

-   Goals are desired world states, not behaviours.
-   Actions never change goals.
-   Actions must leave the world in a consistent state.
-   Continuous needs belong in a Needs system.

------------------------------------------------------------------------

### Ultra Short Summary

    1. Define effects
    2. Define preconditions
    3. Implement execution
    4. Register action
    5. Ensure world state supports it
    6. Ensure goal system desires it

------------------------------------------------------------------------

------------------------------------------------------------------------

## Guide 2 --- Designing Long Chains of Actions

### Core Idea

You do NOT design chains.

You design small actions connected by world states.

    effects of one action = preconditions of another

The planner builds the chain automatically.

------------------------------------------------------------------------

### Step-by-Step Method

#### 1. Start with the Final Goal

Example:

    hungry = false

------------------------------------------------------------------------

#### 2. Create the Action That Achieves the Goal

Example: Eat

    preconditions:
        has_food = true
        hungry = true

    effects:
        hungry = false

This creates a new problem: obtain food.

------------------------------------------------------------------------

#### 3. Create the Action That Produces Missing Requirements

Example: Pick up food

    preconditions:
        at_food = true
        food_exists = true

    effects:
        has_food = true

------------------------------------------------------------------------

#### 4. Continue Backwards Until Trivial

Example chain expansion:

    FindFood → GoToFood → PickUpFood → EatFood

------------------------------------------------------------------------

### Universal Action Chain Pattern

Most simulations follow:

    discover resource
    → move to resource
    → interact with resource
    → obtain object
    → use object
    → change internal state

------------------------------------------------------------------------

### Types of Actions in Long Chains

#### Discovery Actions

-   find food
-   locate bed
-   detect danger

#### Movement Actions

-   go to resource
-   go home
-   go to storage

#### Interaction Actions

-   pick up
-   drop
-   mine
-   harvest

#### Transformation Actions

-   cook
-   craft
-   refine

#### Consumption Actions

-   eat
-   sleep
-   heal

------------------------------------------------------------------------

### Design Test

For each action ask:

    What does it produce?
    Does another action need that?

If yes → chain is valid.

------------------------------------------------------------------------

### Common Mistakes

#### Actions too large

Bad:

    get_food_complete

Good:

    find → move → pick → eat

------------------------------------------------------------------------

#### Ambiguous states

Avoid behaviour states like:

    is_walking
    is_working

Use physical facts:

    has_food
    at_target
    hungry

------------------------------------------------------------------------

#### Preconditions no action can produce

If nothing creates a required state, planning fails.

------------------------------------------------------------------------

### Professional Mental Model

Treat GOAP like chemistry:

    states = molecules
    actions = reactions
    planner = reaction chain

------------------------------------------------------------------------

### Ultra Short Summary

    1. Define final goal
    2. Create action that satisfies it
    3. Create actions that satisfy its preconditions
    4. Repeat until trivial
    5. Keep actions small and connectable

------------------------------------------------------------------------

## End of Document
