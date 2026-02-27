class_name UISystem

func update(world : World, delta):
	player_orders(world, delta)
func player_orders(world : World, delta):
	for order_id in world.query([BuildOrderComponent]):
		spawn_building(world, order_id)

func spawn_building(world: World, id : int) -> void:
	var building_map : TileMapLayer = world.building_map
	var pos = world.get_component(id, PositionComponent)
	
	var workplace_comp = WorkplaceComponent.new()
	world.add(id, workplace_comp)

	
	var base_cell : Vector2i = world.map.local_to_map(pos.value)

	for offset in workplace_comp.form:
		var target_cell = base_cell + offset
		var atlas_coords = workplace_comp.origin_tile + offset
		if(building_map.get_cell_source_id(target_cell)!=-1):
			world.destroy_entity(id)
			print("Lugar ya ocupado")
			return
			
	for offset in workplace_comp.form:
		var target_cell = base_cell + offset
		var atlas_coords = workplace_comp.origin_tile + offset
		building_map.set_cell(target_cell, 0, atlas_coords)
	
	world.remove_component(id, BuildOrderComponent)

func spawn_farm():
	pass

func spawn_kitchen():
	pass
