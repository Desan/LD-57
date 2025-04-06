extends Camera2D

@export var max_radius : float = 200  # Max distance the camera can move from the center point
@export var speed : float = 5.0  # Speed at which the camera moves towards the mouse

var shake_strength: float = 0.0
var shake_decay: float = 5.0  # How fast the shake fades
var max_offset: float = 10.0

@export var center_node : Node2D

func _process(delta):
	# Get the global mouse position
	var mouse_pos = get_global_mouse_position()
	var center_position = center_node.global_position

	# Calculate the distance from the center position (camera's position)
	var distance = center_position.distance_to(mouse_pos)

	# Check if the distance exceeds the max radius
	if distance > max_radius:
		# If it's too far, we clamp the mouse position within the max radius
		var direction = (mouse_pos - center_position).normalized()
		mouse_pos = center_position + direction * max_radius
	
	# Move the camera towards the mouse position
	position = lerp(position, mouse_pos, speed * delta)
	
	_process_shake(delta)

func _process_shake(delta):
	if shake_strength > 0.0:
		var offset_x = randf_range(-1.0, 1.0) * shake_strength * max_offset
		var offset_y = randf_range(-1.0, 1.0) * shake_strength * max_offset
		offset = Vector2(offset_x, offset_y)
		
		shake_strength = max(shake_strength - delta * shake_decay, 0.0)
	else:
		offset = Vector2.ZERO

func start_shake(strength: float = 1.0):
	shake_strength = clamp(strength, 0.0, 1.0)
