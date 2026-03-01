class_name GoalComponent

var goals : Dictionary = {
	"wander": false,
	"move_to_target": false,
	"has_target": false
}

func evaluate(entity: int, world: World) -> void:
	for key in goals:
		goals[key] = false
	
	# ============================================
	# === AGREGAR CONDICIONES AQUÍ ===
	# ============================================
	# Estructura ejemplo:
	#
	# var hunger = world.get_component(entity, HungerComponent)
	# if hunger and hunger.value < 30:
	#     goals["buscar_comida"] = true
	# elif tiene_alguna_mision:
	#     goals["hacer_mision"] = true
	# else:
	#     goals["wander"] = true
	
	# Por defecto: wander
	goals["wander"] = true
