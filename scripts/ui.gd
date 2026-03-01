extends Control

@onready var contenedor = $BuildMenu
@onready var world : World
var opcion_seleccionada

var opciones = []

func _ready() -> void:
	actualizar_menu()

func actualizar_menu():
	if(world==null):
		return
	var input : InputComponent = world.get_component(world.player_id, InputComponent)

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

	var order = world.create_entity()
	var build_order_comp = BuildOrderComponent.new()
	build_order_comp.type = opcion
	world.add(order, build_order_comp)
	world.add(order, PositionComponent.new())
	input.build_mode = true
	input.selected_building = opcion
