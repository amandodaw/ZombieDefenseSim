class_name WorkplaceComponent

var origin_tile : Vector2i = Vector2i(0,1)

var form : Array[Vector2i] = [
	Vector2i(0,0), Vector2i(1,0), Vector2i(2,0),
	Vector2i(0,1), Vector2i(1,1), Vector2i(2,1),
	Vector2i(0,2), Vector2i(1,2), Vector2i(2,2)	
]

var amount_needed : int = 100
var amount_progress : int = 0
var on_use : bool = false
