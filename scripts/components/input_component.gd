class_name InputComponent

enum Buildings {
	FARM,
	KITCHEN,
	HOUSE,
	HUMAN
}

const BUILDING_NAMES = {
	Buildings.FARM: "Farm",
	Buildings.KITCHEN: "Kitchen",
	Buildings.HOUSE: "House",
	Buildings.HUMAN: "Human"
}

var build_mode : bool = false
var selected_building : Buildings
var confirm_order : bool = false
var abort_order : bool = false
var spawn_human : bool = false
