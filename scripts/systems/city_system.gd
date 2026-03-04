class_name CitySystem

func update(world: World, delta):
	for entity in world.query([HumanComponent]):
		var city_id = world.query([CityComponent]).get(0)
		var city : CityComponent = world.get_component(city_id, CityComponent)
		if city.humans.has(entity):
			continue
		city.humans.append(entity)

func add(entity_id : int, delta):
	pass
