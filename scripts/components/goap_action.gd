class_name GoapAction

var name : String
var preconditions : Dictionary = {}
var effects : Dictionary = {}

var is_running : bool = false
var is_finished : bool = false


func start(entity, world):
	is_running = true


func update(entity, world, delta):
	pass


func finish():
	is_running = false
	is_finished = true


func reset():
	is_running = false
	is_finished = false

func apply_effects_to_world(world, entity_id):
	var world_state = world.get_component(entity_id, WorldStateComponent)
	if not world_state:
		return

	for key in effects:
		world_state.state[key] = effects[key]
