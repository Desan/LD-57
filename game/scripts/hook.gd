extends Area2D

@export var max_distance: float = 300.0
@export var speed: float = 900.0
@export var retraction_speed: float = 600.0

@export var hook_point: Node2D

@onready var line_2d: Line2D = $Line2D

var is_retracted: bool = false
var is_grabbed: bool = false

func _ready():
	is_retracted = false
	line_2d.add_point(to_local(hook_point.global_position), 0)
	line_2d.add_point(Vector2.ZERO, 1)
	body_entered.connect(handle_collision)

func _physics_process(delta):
	if is_retracted:
		var direction = hook_point.global_position - global_position
		direction = direction.normalized()
		var effective_speed = speed
		if is_grabbed:
			effective_speed = retraction_speed
		position += direction * effective_speed * delta
	else:
		position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _process(delta):
	var distance_to_hook_point = position.distance_to(hook_point.global_position)
	if distance_to_hook_point > max_distance:
		is_retracted = true
		
	if distance_to_hook_point < 10 and is_retracted:
		EventBus.hook_retacted.emit()
		if is_grabbed:
			EventBus.crate_looted.emit()
		queue_free()
	
	line_2d.set_point_position(0, to_local(hook_point.global_position))

func handle_collision(body):
	if is_retracted: return
	
	if body is Collectable:
		body.grab.bind(self).call_deferred()
		is_retracted = true
		is_grabbed = true
