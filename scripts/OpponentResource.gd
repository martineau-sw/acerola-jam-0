class_name OpponentResource
extends Resource

@export var ego: int
@export var sol: int

@export var men: int
@export var phy: int
@export var prs: int
@export var soc: int

@export var brain_health: int
@export var eye_r_health: int
@export var eye_l_health: int
@export var mouth_health: int


signal ego_damaged(amt: int)
signal brain_damaged(amt: int)
signal eye_r_damaged(amt: int)
signal eye_l_damaged(amt: int)
signal mouth_damaged(amt: int)

signal ego_empty
signal brain_empty
signal eye_r_empty
signal eye_l_empty
signal mouth_empty

# Called when the node enters the scene tree for the first time.
func _ready():
	brain_damaged.connect(
		func(amt):
			brain_health -= amt
			if(brain_health <= 0):
				brain_empty.emit()
	)
	
	eye_r_damaged.connect(
		func(amt):
			eye_r_health -= amt
			if(eye_r_health <= 0):
				eye_r_empty.emit()
	)
	
	eye_l_damaged.connect(
		func(amt):
			eye_l_health -= amt
			if(eye_l_health <= 0):
				eye_l_empty.emit()
	)
	
	mouth_damaged.connect(
		func(amt):
			mouth_health -= amt
			if(mouth_health <= 0):
				mouth_empty.emit()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


