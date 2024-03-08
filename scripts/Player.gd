extends RigidBody3D

@export var max_speed: float = 1.
@export var acceleration_scale: float = 1.
@export var deceleration_scale: float = 0.05

var _velocity: Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = _get_input_direction()

	_accelerate(input)
	_apply_friction()
	
	_velocity = _velocity.clamp(-Vector3.ONE * max_speed, Vector3.ONE * max_speed)
	position += _velocity * delta

func _get_input_direction():
	var input_direction = Vector3.ZERO
	
	if(Input.is_action_pressed(&"move_up")):
		input_direction.z -= 1.
	if(Input.is_action_pressed(&"move_down")):
		input_direction.z += 1.
	if(Input.is_action_pressed(&"move_right")):
		input_direction.x += 1.
	if(Input.is_action_pressed(&"move_left")):
		input_direction.x -= 1.
		
	return input_direction

func _accelerate(increment: Vector3):
	_velocity += increment * acceleration_scale
	
	
func _apply_friction():
	_velocity -= _velocity * deceleration_scale 
	
	if(is_zero_approx(_velocity.length_squared())):
		_velocity = Vector3.ZERO
