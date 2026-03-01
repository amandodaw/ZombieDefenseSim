class_name GoapAction

var name : String
var preconditions : Dictionary = {}
var effects : Dictionary = {}

var is_running : bool = false
var is_finished : bool = false


func start(entity, world):
	is_running = true


func update(entity, world, delta):
	pass


func finish():
	is_running = false
	is_finished = true


func reset():
	is_running = false
	is_finished = false
