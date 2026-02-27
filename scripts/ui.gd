extends Control

@onready var container = $Panel/VBoxContainer

enum WorkplaceType {
	FARM,
	KITCHEN,
	HOUSE
}

var building_data = {
	WorkplaceType.FARM: {
		"name": "Granja"
	},
	WorkplaceType.KITCHEN: {
		"name": "Cocina"
	},
	WorkplaceType.HOUSE: {
		"name": "Casa"
	}
}

var available_buildings = [
	WorkplaceType.FARM,
	WorkplaceType.KITCHEN,
	WorkplaceType.HOUSE
]

var selected_building : WorkplaceType

func _ready():
	build_menu()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		accept_event()

func build_menu():
	for type in available_buildings:

		var button = Button.new()
		button.text = building_data[type].name

		# guardar qué edificio representa
		button.pressed.connect(_on_building_selected.bind(type))

		container.add_child(button)

func _on_building_selected(type: WorkplaceType):
	selected_building = type
	print("Seleccionado:", building_data[type].name)
