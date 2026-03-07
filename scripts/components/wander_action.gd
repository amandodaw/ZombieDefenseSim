class_name WanderAction
extends GoapAction

const DEFAULT_RADIUS_TILES : int = 6
const DEFAULT_TIMEOUT_SECONDS : float = 6.0
const MAX_SAMPLES : int = 24

var _rng := RandomNumberGenerator.new()
var _target_position : Vector2 = Vector2.ZERO
var _has_target : bool = false
var _elapsed_seconds : float = 0.0


func _init():
	name = "Wander action"
	
	preconditions = {
		"wander": false
	}
	effects = {
		"wander": true
	}

func start(entity, world):
	super.start(entity, world)
	_elapsed_seconds = 0.0
	_has_target = false

	_rng.seed = int(Time.get_ticks_msec()) ^ int(entity)

	var pos : PositionComponent = world.get_component(entity, PositionComponent)
	if pos == null:
		finish()
		return

	var target = _pick_target(world, pos.value, DEFAULT_RADIUS_TILES)
	if target == null:
		finish()
		return

	_target_position = target
	_has_target = true

	var world_state : WorldStateComponent = world.get_component(entity, WorldStateComponent)
	if world_state != null:
		world_state.target_pos = _target_position


func update(entity, world, delta):
	if not is_running or is_finished:
		return

	_elapsed_seconds += delta
	if _elapsed_seconds >= DEFAULT_TIMEOUT_SECONDS:
		_finish_and_stop(entity, world)
		return

	if not _has_target:
		_finish_and_stop(entity, world)
		return

	var pos : PositionComponent = world.get_component(entity, PositionComponent)
	var move : MovementComponent = world.get_component(entity, MovementComponent)
	if pos == null or move == null:
		finish()
		return

	var direction : Vector2 = (_target_position - pos.value)
	if direction.length() < move.speed * delta + 5.0:
		_finish_and_stop(entity, world)
		return

	move.direction = direction.normalized()


func _finish_and_stop(entity, world) -> void:
	var move : MovementComponent = world.get_component(entity, MovementComponent)
	if move != null:
		move.direction = Vector2.ZERO
	finish()


func _pick_target(world, from_pos: Vector2, radius_tiles: int):
	var map_layer = world.map_layer
	if map_layer == null:
		return null

	var max_x_px : float = float((int(map_layer.map_heigh) - 1) * GridUtils.TILE_SIZE)
	var max_y_px : float = float((int(map_layer.map_width) - 1) * GridUtils.TILE_SIZE)

	var radius_px : int = radius_tiles * GridUtils.TILE_SIZE
	if radius_px <= 0:
		radius_px = GridUtils.TILE_SIZE

	var origin_tile : Vector2i = map_layer.local_to_map(from_pos)
	var best : Vector2 = Vector2.ZERO
	var found := false

	for _i in MAX_SAMPLES:
		var offset_px := Vector2(
			float(_rng.randi_range(-radius_px, radius_px)),
			float(_rng.randi_range(-radius_px, radius_px))
		)
		if offset_px == Vector2.ZERO:
			continue

		var candidate_px := from_pos + offset_px
		candidate_px.x = clampf(candidate_px.x, 0.0, max_x_px)
		candidate_px.y = clampf(candidate_px.y, 0.0, max_y_px)

		var candidate_tile : Vector2i = map_layer.local_to_map(candidate_px)
		if candidate_tile == origin_tile:
			continue

		if world.building_map != null and world.building_map.get_cell_source_id(candidate_tile) != -1:
			continue

		best = candidate_px
		found = true
		break

	if not found:
		return null

	return best
