extends Node2D

@export var max_radius : float = 200  # Max distance the camera can move from the center point
@export var speed : float = 5.0  # Speed at which the camera moves towards the mouse

@export var center_node: Node2D

var adjust_position: Vector2

func _input(event):
	if event and event is InputEventMouseMotion:
		adjust_position = event.relative

func _process(delta):
	var derisred_pos = position + adjust_position
	var center_position = center_node.position

	# Calculate the distance from the center position
	var distance = center_position.distance_to(center_node.position)

	# Check if the distance exceeds the max radius
	if distance > max_radius:
		# If it's too far, we clamp the mouse position within the max radius
		var direction = (derisred_pos - center_position).normalized()
		derisred_pos = center_position + direction * max_radius

	# Move the camera towards the mouse position
	position = lerp(position, derisred_pos, speed * delta)
