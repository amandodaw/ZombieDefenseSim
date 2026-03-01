class_name BuildingSystem

func update(world : World, delta):
	for order_id in world.query([BuildOrderComponent]):
		var input : InputComponent = world.get_component(world.player_id, InputComponent)
		var build_order : BuildOrderComponent = world.get_component(order_id, BuildOrderComponent)
		if input.abort_order:
			world.destroy_entity(order_id)
			world.preview_map.clear()
			input.abort_order = false
		if input.build_mode:
			preview_building(world, order_id, input)
		if input.confirm_order and build_order.valid_pos:
			spawn_building(world, order_id, input)


func preview_building(world : World, id : int, input : InputComponent) -> void:
	var preview_map : TileMapLayer = world.preview_map
	var building_map : TileMapLayer = world.building_map
	var pos = world.get_component(id, PositionComponent)
	var build_order : BuildOrderComponent = world.get_component(id, BuildOrderComponent)
	
	preview_map.clear()
	pos.value = world.get_global_mouse_position()

	var workplace_comp = _get_or_create_workplace_component(world, id, build_order.type)
	if workplace_comp == null:
		return

	var base_cell : Vector2i = world.map_layer.local_to_map(pos.value)

	_render_preview(world, base_cell, workplace_comp)
	
	if _check_valid_position(world, base_cell, workplace_comp):
		build_order.valid_pos = true
	else:
		build_order.valid_pos = false
		input.confirm_order = false


func spawn_building(world: World, id : int, input : InputComponent) -> void:
	var preview_map : TileMapLayer = world.preview_map
	var building_map : TileMapLayer = world.building_map
	var pos = world.get_component(id, PositionComponent)
	
	preview_map.clear()

	var workplace_comp = world.get_component(id, WorkplaceComponent)
	if workplace_comp == null:
		return

	var base_cell : Vector2i = world.map_layer.local_to_map(pos.value)

	if not _check_valid_position(world, base_cell, workplace_comp):
		print("Lugar ya ocupado")
		return

	_place_building(world, base_cell, workplace_comp)

	world.remove_component(id, BuildOrderComponent)
	input.build_mode = false
	input.confirm_order = false


func _get_or_create_workplace_component(world: World, entity_id: int, building_type: int) -> WorkplaceComponent:
	var workplace_comp = WorkplaceComponent.new()
	match building_type:
		0:
			var farm_comp = FarmComponent.new()
			world.add(entity_id, farm_comp)
			workplace_comp.form = farm_comp.form
			workplace_comp.origin_tile = farm_comp.origin_tile
	
	world.add(entity_id, workplace_comp)
	return workplace_comp


func _check_valid_position(world: World, base_cell: Vector2i, workplace_comp: WorkplaceComponent) -> bool:
	for offset in workplace_comp.form:
		var target_cell = base_cell + offset
		if world.building_map.get_cell_source_id(target_cell) != -1:
			return false
	return true


func _render_preview(world: World, base_cell: Vector2i, workplace_comp: WorkplaceComponent) -> void:
	for offset in workplace_comp.form:
		var target_cell = base_cell + offset
		var atlas_coords = workplace_comp.origin_tile + offset
		world.preview_map.set_cell(target_cell, 0, atlas_coords)


func _place_building(world: World, base_cell: Vector2i, workplace_comp: WorkplaceComponent) -> void:
	for offset in workplace_comp.form:
		var target_cell = base_cell + offset
		var atlas_coords = workplace_comp.origin_tile + offset
		world.building_map.set_cell(target_cell, 0, atlas_coords)


func spawn_farm():
	pass


func spawn_kitchen():
	pass
