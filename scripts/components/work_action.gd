class_name WorkAction
extends GoapAction

var target_position : Vector2i


func _init():
	name = "Work action"
	
	preconditions = {
		"at_target": true
	}
	effects = {
		"enough_resources": true
	}

func start(entity, world):
	super.start(entity, world)

func update(entity, world, delta):

	var worker : WorkerComponent = world.get_component(entity, WorkerComponent)

	if worker.workplace == -1:
		finish()
		return

	var workplace : WorkplaceComponent = world.get_component(worker.workplace, WorkplaceComponent)

	workplace.work_done += delta * 10
	print("Trabajado: ", workplace.work_done)
	if workplace.work_done >= workplace.work_needed:
		workplace.work_done = 0
		print("Trabajo finalizado en taller ", worker.workplace)
		finish()
		var world_state = world.get_component(entity, WorldStateComponent).state
		world_state["enough_resources"] = false
