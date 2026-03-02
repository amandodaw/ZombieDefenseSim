class_name PerceptionSystem

var spatial : SpatialIndexSystem


func _init(_spatial):
	spatial = _spatial


func update(world, delta):

	for entity in world.query([
		PositionComponent,
		VisionComponent
	]):

		var vision : VisionComponent = world.get_component(entity, VisionComponent)

		vision.time_until_update -= delta
		if vision.time_until_update > 0:
			continue

		vision.time_until_update = vision.update_interval

		_update_entity_perception(world, entity)


# --------------------------------------------------

func _update_entity_perception(world, entity):
	
	var pos : PositionComponent = world.get_component(entity, PositionComponent)
	var vision : VisionComponent = world.get_component(entity, VisionComponent)

	vision.visible_entities.clear()

	var center : Vector2i = GridUtils.world_to_tile(pos.value)
	var r : int = vision.range
	print("ENTITY", entity, "AT", center, "RANGE", r)
	for x in range(center.x - r, center.x + r + 1):
		for y in range(center.y - r, center.y + r + 1):

			var tile := Vector2i(x, y)

			var list = spatial.tile_entities.get(tile, null)
			if list == null:
				continue

			for other in list:
				if other != entity:
					vision.visible_entities.append(other)
	print("CENTER:", center)
	print("SPATIAL TILES:", spatial.tile_entities.keys())
