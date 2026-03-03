class_name BuildingSystem

func update(world : World, delta):
	for order_id in world.query([BuildOrderComponent]):
		var input : InputComponent = world.get_component(world.player_id, InputComponent)
		var build_order : BuildOrderComponent = world.get_component(order_id, BuildOrderComponent)
		
		match build_order.state:
			BuildOrderComponent.State.ABORTED:
				world.destroy_entity(order_id)
				world.preview_map.clear()
				build_order.state = BuildOrderComponent.State.PENDING
				input.build_mode = false
				input.abort_order = false

			BuildOrderComponent.State.PENDING:
				if input.build_mode:
					build_order.state = BuildOrderComponent.State.PREVIEW

			BuildOrderComponent.State.PREVIEW:
				preview_building(world, order_id, input)
				if input.confirm_order and build_order.valid_pos:
					build_order.state = BuildOrderComponent.State.CONFIRMED
				elif input.abort_order:
					build_order.state = BuildOrderComponent.State.ABORTED

			BuildOrderComponent.State.CONFIRMED:
				spawn_building(world, order_id, input)
				input.confirm_order = false
				build_order.state = BuildOrderComponent.State.PENDING


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
		preview_map.self_modulate = Color(1, 1, 1, 0.7)
		build_order.valid_pos = true
	else:
		preview_map.self_modulate = Color(1, 0, 0, 0.5)
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

	_place_building(world, base_cell, workplace_comp)

	world.remove_component(id, BuildOrderComponent)
	input.build_mode = false
	var city_id = world.query([CityComponent]).get(0)
	var city = world.get_component(city_id, CityComponent)
	city.buildings.append(id)


func _get_or_create_workplace_component(world: World, entity_id: int, building_type: int) -> WorkplaceComponent:
	var workplace_comp = WorkplaceComponent.new()
	var type_comp
	match building_type:
		0:
			type_comp = FarmComponent.new()
		1:
			type_comp = KitchenComponent.new()
		2:
			type_comp = HouseComponent.new()
	world.add(entity_id, type_comp)
	workplace_comp.form = type_comp.form
	workplace_comp.origin_tile = type_comp.origin_tile
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
