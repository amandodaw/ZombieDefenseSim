class_name BuildOrderComponent

enum Buildings {
	FARM,
	KITCHEN,
	HOUSE
}

enum State { PENDING, PREVIEW, CONFIRMED, ABORTED }

var type : Buildings
var state : State = State.PENDING
var valid_pos : bool = false
