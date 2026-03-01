class_name GoapSystem

func update(world: World, delta):
	for entity in world.query(
		[GoalComponent]
	):
		pass
