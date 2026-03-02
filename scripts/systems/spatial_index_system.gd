class_name SpatialIndexSystem

# tile -> Array[entity_id]
var tile_entities : Dictionary = {}

# entity_id -> tile actual
var entity_tiles : Dictionary = {}


func update(world, delta):

	for entity in world.query([PositionComponent]):

		var pos : PositionComponent = world.get_component(entity, PositionComponent)
		var tile : Vector2i = GridUtils.world_to_tile(pos.value)

		var previous_tile = entity_tiles.get(entity, null)

		if previous_tile == tile:
			continue

		_remove_from_tile(entity, previous_tile)
		_add_to_tile(entity, tile)

		entity_tiles[entity] = tile


# --------------------------------------------------
# INTERNAL
# --------------------------------------------------

func _add_to_tile(entity, tile: Vector2i):

	if not tile_entities.has(tile):
		tile_entities[tile] = []

	tile_entities[tile].append(entity)


func _remove_from_tile(entity, tile):

	if tile == null:
		return

	if not tile_entities.has(tile):
		return

	tile_entities[tile].erase(entity)

	if tile_entities[tile].is_empty():
		tile_entities.erase(tile)


func remove_entity(entity):
	# Llamar cuando eliminas entidad del mundo
	var tile = entity_tiles.get(entity, null)
	_remove_from_tile(entity, tile)
	entity_tiles.erase(entity)


# --------------------------------------------------
# HELPERS PUBLICOS
# --------------------------------------------------

func get_entities_in_tile(tile: Vector2i) -> Array:
	return tile_entities.get(tile, [])


func get_entities_in_range(center: Vector2i, range_value: int) -> Array:

	var result := []

	for x in range(center.x - range_value, center.x + range_value + 1):
		for y in range(center.y - range_value, center.y + range_value + 1):

			var tile := Vector2i(x, y)
			var list = tile_entities.get(tile, null)

			if list != null:
				result.append_array(list)

	return result


func is_tile_occupied(tile: Vector2i) -> bool:
	return tile_entities.has(tile) and tile_entities[tile].size() > 0

func filter_entities_with_component(world, entities, component_type):

	var result := []

	for e in entities:
		if world.has_component(e, component_type):
			result.append(e)

	return result

func is_tile_blocked_by_building(world, spatial, tile):

	var entities = spatial.get_entities_in_tile(tile)

	for e in entities:
		if world.has_component(e, BuildingComponent):
			return true

	return false

func get_visible_of_type(world, vision: VisionComponent, component_type):

	var result := []

	for e in vision.visible_entities:
		if world.has_component(e, component_type):
			result.append(e)

	return result
