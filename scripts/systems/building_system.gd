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
	var build_order = world.get_component(id, BuildOrderComponent)
	preview_map.clear()
	pos.value = world.get_global_mouse_position()
	
	var workplace_comp = WorkplaceComponent.new()
	world.add(id, workplace_comp)

	
	var base_cell : Vector2i = world.map_layer.local_to_map(pos.value)


	for offset in workplace_comp.form:
		var target_cell = base_cell + offset
		var atlas_coords = workplace_comp.origin_tile + offset
		preview_map.set_cell(target_cell, 0, atlas_coords)
	
	for offset in workplace_comp.form:
		var target_cell = base_cell + offset
		var atlas_coords = workplace_comp.origin_tile + offset
		if(building_map.get_cell_source_id(target_cell)!=-1):
			build_order.valid_pos = false
			input.confirm_order = false
			return
	build_order.valid_pos = true

func spawn_building(world: World, id : int, input : InputComponent) -> void:
	var building_map : TileMapLayer = world.building_map
	var preview_map : TileMapLayer = world.preview_map
	var pos = world.get_component(id, PositionComponent)
	preview_map.clear()

	
	var workplace_comp = WorkplaceComponent.new()
	world.add(id, workplace_comp)

	
	var base_cell : Vector2i = world.map_layer.local_to_map(pos.value)

	for offset in workplace_comp.form:
		var target_cell = base_cell + offset
		var atlas_coords = workplace_comp.origin_tile + offset
		if(building_map.get_cell_source_id(target_cell)!=-1):
			print("Lugar ya ocupado")
			return
			
	for offset in workplace_comp.form:
		var target_cell = base_cell + offset
		var atlas_coords = workplace_comp.origin_tile + offset
		building_map.set_cell(target_cell, 0, atlas_coords)
	
	world.remove_component(id, BuildOrderComponent)
	input.build_mode = false
	input.confirm_order = false

func spawn_farm():
	pass

func spawn_kitchen():
	pass
