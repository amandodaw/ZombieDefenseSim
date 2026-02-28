extends TileMapLayer

var map_heigh : int = 100
var map_width: int = 100

var ground_cell : Vector2i = Vector2i(1, 0)

func _ready() -> void:
	for i in map_heigh:
		for j in map_width:
			set_cell(Vector2i(i, j), 0, ground_cell)
