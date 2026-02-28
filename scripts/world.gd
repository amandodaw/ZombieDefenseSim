extends Node2D
class_name World

@onready var camera = $PlayerCamera
@onready var map = $MapLayers
@onready var map_layer = $MapLayers/MapLayer
@onready var building_map = $MapLayers/BuildingLayer
@onready var preview_map = $MapLayers/PreviewLayer
@onready var ui = $UI/Control

var player_id : int = 0
# =========================================================
# ENTIDADES
# =========================================================

var _next_entity_id : int = 0

func create_entity() -> int:
	var id = _next_entity_id
	_next_entity_id += 1
	return id

# =========================
# COMPONENTES
# =========================
var components := {}

func add(entity: int, component) -> void:
	var type = component.get_script()
	
	if not components.has(type):
		components[type] = {}
	components[type][entity] = component

func get_component(entity: int, type):
	if components.has(type) and components[type].has(entity):
		return components[type][entity]
	return

func has_component(entity: int, type) -> bool:
	return components.has(type) and components[type].has(entity)

func remove_component(entity: int, type) -> void:
	if components.has(type):
		components[type].erase(entity)

func destroy_entity(entity: int) -> void:
	for type in components.keys():
		components[type].erase(entity)

# =========================================================
# QUERY
# devuelve entidades que tienen TODOS los tipos pedidos
# =========================================================

func query(required_types: Array) -> Array:
	
	if required_types.is_empty():
		return []
	
	var first_type = required_types[0]
	if not components.has(first_type):
		return []
	
	var result := []
	
	for entity in components[first_type].keys():
		
		var valid = true
		
		for t in required_types:
			if not has_component(entity, t):
				valid = false
				break
		
		if valid:
			result.append(entity)
	
	return result
	
# =========================
# SISTEMAS
# =========================
var systems : Array = []

func register_system(system) -> void:
	systems.append(system)

var input_system : InputSystem
var building_system : BuildingSystem
var ui_system : UISystem

func _ready() -> void:
	input_system = InputSystem.new()
	building_system = BuildingSystem.new()
	ui_system = UISystem.new()
	
	ui.world = self
	
	register_system(input_system)
	register_system(building_system)
	#register_system(ui_system)
	
	create_player()
	ui.actualizar_menu()

func _physics_process(delta: float) -> void:
	for system in systems:
		system.update(self, delta)

func create_player() -> void :
	player_id = create_entity()
	add(player_id, InputComponent.new())
