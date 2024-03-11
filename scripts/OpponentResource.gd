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
	ego_damaged.connect(
		func(amt):
			print("enemy ego damaged: %d" % amt)
			ego -= amt
			if(ego <= 0):
				ego_empty.emit()
			BattleManager.enqueue.emit("enemy_damaged")
	)
	
	brain_damaged.connect(
		func(amt):
			print("enemy brain damaged: %d" % amt)
			brain_health -= amt
			if(brain_health <= 0):
				brain_empty.emit()
			BattleManager.enqueue.emit("brain_damaged")
	)
	
	eye_r_damaged.connect(
		func(amt):
			print("enemy right eye damaged: %d" % amt)
			eye_r_health -= amt
			if(eye_r_health <= 0):
				eye_r_empty.emit()
			BattleManager.enqueue.emit("eye_r_damaged")
	)
	
	eye_l_damaged.connect(
		func(amt):
			print("enemy left eye damaged: %d" % amt)
			eye_l_health -= amt
			if(eye_l_health <= 0):
				eye_l_empty.emit()
			BattleManager.enqueue.emit("eye_l_damaged")
	)
	
	mouth_damaged.connect(
		func(amt):
			print("enemy mouth damaged: %d" % amt)
			mouth_health -= amt
			if(mouth_health <= 0):
				mouth_empty.emit()
			BattleManager.enqueue.emit("mouth_damaged")
	)

