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

	var world_state = world.get_component(entity, WorldStateComponent)

	var worker : WorkerComponent = world.get_component(entity, WorkerComponent)
	
	var move : MovementComponent = world.get_component(entity, MovementComponent)

	if worker.workplace == -1:
		finish()
		return
	
	#if world.get_component(worker.workplace, PositionComponent).value != world_state.target_pos:
		#finish()
		#world_state.target_pos = world.get_component(worker.workplace, PositionComponent).value
		#world_state.state["at_target"] = false
		#world_state.state["enough_resources"] = false
		#print("No esta en el sitio de trabajo:", world_state.state)
		#return

	var workplace : WorkplaceComponent = world.get_component(worker.workplace, WorkplaceComponent)

	workplace.work_done += delta * 10
	print("Trabajado: ", workplace.work_done)
	if workplace.work_done >= workplace.work_needed:
		workplace.work_done = 0
		print("Trabajo finalizado en taller ", worker.workplace)
		finish()
		world_state.state["enough_resources"] = false
