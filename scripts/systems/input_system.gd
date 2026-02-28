class_name InputSystem

func update(world: World, delta):
	var camera : Camera2D = world.camera
	var map : TileMapLayer = world.map_layer
	var ui : Control = world.ui
	var player_input : InputComponent = world.get_component(world.player_id, InputComponent)
	if Input.is_action_just_pressed("left_click"):
		if player_input.build_mode:
			print(map.local_to_map(world.get_global_mouse_position()))
			player_input.confirm_order = true
	if Input.is_action_just_pressed("right_click"):
		if player_input.build_mode and !player_input.abort_order:
			player_input.build_mode = false
			player_input.abort_order = true
	if Input.is_action_just_pressed("build_menu"):
		ui.visible = !ui.visible
	
