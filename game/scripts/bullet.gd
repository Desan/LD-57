extends Node2D

@onready var line_2d = $Line2D
@onready var timer = $Timer

@export var damage := 3
@export var speed := 1500

func _ready():
	set_as_top_level(true)
	timer.start()
	timer.timeout.connect(destroy)

func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func destroy():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("damageable"):
		body.take_damage(damage, Vector2.RIGHT.rotated(rotation))
		destroy()
