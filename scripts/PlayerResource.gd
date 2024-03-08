class_name PlayerResource
extends Resource

@export var ego_max: int
@export var ego: int
@export var sol: int
@export var men: int
@export var phy: int
@export var prs: int
@export var soc: int

signal ego_damaged(amt: int)
signal ego_empty

# Called when the node enters the scene tree for the first time.
func _ready():
	ego = ego_max
	
	ego_damaged.connect(
		func(amt):
			ego -= amt
			if(ego <= 0): ego_empty.emit()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
