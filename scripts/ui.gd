extends Control

@onready var contenedor = $BuildMenu
@onready var worker_menu = $WorkMenu
@onready var world : World
var opcion_seleccionada

var opciones = []

func _ready() -> void:
	actualizar_menu()

func actualizar_menu():
	if(world==null):
		return
	var input : InputComponent = world.get_component(world.player_id, InputComponent)
	
	world.connect("human_created", _on_human_created)
	
	# Borrar botones anteriores
	for hijo in contenedor.get_children():
		hijo.queue_free()
	
	# Crear nuevos botones
	for opcion in input.Buildings.values():
		var boton = Button.new()
		boton.text = input.BUILDING_NAMES[opcion]
		boton.pressed.connect(_on_boton_presionado.bind(opcion))
		contenedor.add_child(boton)


func _on_boton_presionado(opcion):
	print(opcion)
	var input : InputComponent = world.get_component(world.player_id, InputComponent)

	if opcion==input.Buildings.HUMAN:
		input.spawn_human = true
	else:
		var order = world.create_entity()
		var build_order_comp = BuildOrderComponent.new()
		build_order_comp.type = opcion
		world.add(order, build_order_comp)
		world.add(order, PositionComponent.new())
		input.build_mode = true
		input.selected_building = opcion

func update_worker_menu():
	if(world==null):
		return
	var city_comp : CityComponent = world.get_component(world.player_id, CityComponent)

	# Borrar botones anteriores
	for option in worker_menu.get_children():
		option.queue_free()
	
	# Crear nuevos botones
	for worker in city_comp.humans:
		var boton = Button.new()
		boton.text = str(worker)
		boton.pressed.connect(_on_worker_button.bind(worker))
		worker_menu.add_child(boton)


func _on_worker_button(worker_id : int):

	var option_button = OptionButton.new()
	option_button.set_allow_reselect(true)

	option_button.add_item("Ninguno")
	option_button.set_item_id(0, -1)

	for workplace in world.city_comp.buildings:

		var wp_comp : WorkplaceComponent = world.get_component(workplace, WorkplaceComponent)

		option_button.add_item(wp_comp.name + " " + str(workplace))

		var index = option_button.item_count - 1
		option_button.set_item_id(index, workplace) # ← el entity_id real

	option_button.connect("item_selected", _on_item_selected.bind(option_button, worker_id))

	worker_menu.add_child(option_button)

func _on_item_selected(index, _option_button, worker_id):

	var option_button : OptionButton = _option_button

	var workplace_id = option_button.get_item_id(index)

	var worker_comp : WorkerComponent = world.get_component(worker_id, WorkerComponent)
	
	worker_comp.workplace = workplace_id
	if workplace_id==-1:
		world.goal_system.invalidate_plan(worker_id, world)

	option_button.queue_free()

	print("Trabajador:", worker_id, "asignado a edificio:", workplace_id)

func _on_human_created(human_id : int) ->void:
	update_worker_menu()
