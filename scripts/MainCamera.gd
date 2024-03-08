extends Camera3D


@export var target: Node3D

var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	velocity = Vector3(
		target.global_position.x - global_position.x,
		0,
		target.global_position.z - global_position.z + 3.5)
	
	position += velocity * delta
	

	
