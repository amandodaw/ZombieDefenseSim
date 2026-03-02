class_name GridUtils

const TILE_SIZE = 16

static func world_to_tile(pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(pos.x / TILE_SIZE),
		floor(pos.y / TILE_SIZE)
	)

static func tile_to_world(tile: Vector2i) -> Vector2:
	return Vector2(
		tile.x * TILE_SIZE,
		tile.y * TILE_SIZE
	)
