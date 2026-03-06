extends Node2D
class_name World

@onready var camera = $PlayerCamera
@onready var map = $MapLayers
@onready var map_layer = $MapLayers/MapLayer
@onready var building_map = $MapLayers/BuildingLayer
@onready var preview_map = $MapLayers/PreviewLayer
@onready var ui = $UI/Control

var human_scene : PackedScene = preload("res://scenes/human.tscn")

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

# Índice invertido: entity -> {type: true, ...}
var _entity_components := {}

# Cache de queries
var _query_cache := {}

func _invalidate_cache():
	_query_cache.clear()

func add(entity: int, component) -> void:
	var type = component.get_script()
	
	if not components.has(type):
		components[type] = {}
	components[type][entity] = component
	
	if not _entity_components.has(entity):
		_entity_components[entity] = {}
	_entity_components[entity][type] = true
	
	_invalidate_cache()

func get_component(entity: int, type):
	if components.has(type) and components[type].has(entity):
		return components[type][entity]
	return

func has_component(entity: int, type) -> bool:
	return components.has(type) and components[type].has(entity)

func remove_component(entity: int, type) -> void:
	if components.has(type):
		components[type].erase(entity)
	
	if _entity_components.has(entity):
		_entity_components[entity].erase(type)
	
	_invalidate_cache()

func destroy_entity(entity: int) -> void:
	for type in components.keys():
		components[type].erase(entity)
	
	_entity_components.erase(entity)
	_invalidate_cache()

# =========================================================
# QUERY
# devuelve entidades que tienen TODOS los tipos pedidos
# =========================================================

func query(required_types: Array) -> Array:
	
	if required_types.is_empty():
		return []
	
	var cache_key = required_types.hash()
	if _query_cache.has(cache_key):
		return _query_cache[cache_key]
	
	var result = _query_optimizado(required_types)
	_query_cache[cache_key] = result
	return result

# Este no se usa aun
func _query_optimizado(required_types: Array) -> Array:
	var base_type = _get_smallest_component_type(required_types)
	if not components.has(base_type):
		return []
	
	var result := []
	for entity in components[base_type].keys():
		if _entity_components.has(entity) and _entity_components[entity].has_all(required_types):
			result.append(entity)
	return result

func _get_smallest_component_type(types: Array) -> Resource:
	var smallest_type = types[0]
	var smallest_count = INF
	for t in types:
		if not components.has(t):
			continue
		var count = components[t].size()
		if count < smallest_count:
			smallest_count = count
			smallest_type = t
	return smallest_type
	
# =========================
# SISTEMAS
# =========================
var systems : Array = []

func register_system(system) -> void:
	systems.append(system)

var input_system : InputSystem
var building_system : BuildingSystem
var ui_system : UISystem
var physics_system : PhysicsSystem
var goal_system : GoalSystem
var goap_system : GoapSystem
var replan_system : ReplanSystem
var goap_execution_system : GoapExecutionSystem
var city_system : CitySystem
var spatial_index_system : SpatialIndexSystem
var perception_system : PerceptionSystem

var city_comp : CityComponent

# =========================
# UI
# =========================
signal human_created(human_id)
signal building_created(building_id)
func _ready() -> void:
	input_system = InputSystem.new()
	building_system = BuildingSystem.new()
	ui_system = UISystem.new()
	physics_system = PhysicsSystem.new()
	goal_system = GoalSystem.new()
	goap_system = GoapSystem.new()
	replan_system = ReplanSystem.new()
	goap_execution_system = GoapExecutionSystem.new()
	city_system = CitySystem.new()
	spatial_index_system = SpatialIndexSystem.new()
	perception_system = PerceptionSystem.new(spatial_index_system)
	
	ui.world = self
	
	
	register_system(input_system)
	register_system(building_system)
	register_system(city_system)
	register_system(spatial_index_system)
	register_system(perception_system)
	register_system(goal_system)
	register_system(goap_system)
	register_system(replan_system)
	register_system(goap_execution_system)
	register_system(physics_system)
	#register_system(ui_system)
	
	create_player()
	ui.actualizar_menu()
	add(player_id, CityComponent.new())
	city_comp = get_component(player_id, CityComponent)

func _process(delta: float) -> void:
	for system in systems:
		system.update(self, delta)

func create_player() -> void :
	player_id = create_entity()
	add(player_id, InputComponent.new())

func create_human(pos : Vector2i) -> void:
	var human_id = create_entity()
	var position = PositionComponent.new()
	position.value = pos
	add(human_id, position)
	var move = MovementComponent.new()
	var goal = GoalComponent.new()
	add(human_id, goal)
	add(human_id, ActionComponent.new())
	add(human_id, PlanComponent.new())
	var world_state = WorldStateComponent.new()
	add(human_id, move)
	add(human_id, world_state)
	add(human_id, HumanComponent.new())
	add(human_id, PerceptionComponent.new())
	add(human_id, VisionComponent.new())
	add(human_id, WorkerComponent.new())

	var sprite_component = SpriteComponent.new()
	add(human_id, sprite_component)
	var human = human_scene.instantiate()
	human.global_position = pos
	add_child(human)
	sprite_component.sprite = human
	
	city_comp.humans.append(human_id)
	emit_signal("human_created", human_id)
