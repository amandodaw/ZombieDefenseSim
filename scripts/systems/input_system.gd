class_name InputSystem

func update(world: World, delta):
	var camera : Camera2D = world.camera
	var map : TileMapLayer = world.map
	if Input.is_action_just_pressed("left_click"):
		print(map.local_to_map(world.get_global_mouse_position()))
		var order = world.create_entity()
		world.add(order, BuildOrderComponent.new())
		world.add(order, PositionComponent.new())
		world.get_component(order, PositionComponent).value = world.get_global_mouse_position()
