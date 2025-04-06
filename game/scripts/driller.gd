extends RigidBody2D

var target: Node2D

@export var max_hp: int = 10
var current_hp: int = 0

@export var damage: int = 10
@export var damage_rate: float = 3.0

@export var acceleration: float = 8000.0
@export var max_speed: float = 50.0
@export var turn_speed: float = 10.0
@export var vxf_damage_scene: PackedScene

@onready var damage_timer = $Timer

var drilling_target: Node2D

func _ready():
	current_hp = max_hp
	await get_tree().create_timer(0.2).timeout
	target = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	if not target: return
	
	var to_target = (target.global_position - global_position).normalized()
	
	var desired_angle = to_target.angle()
	var angle_diff = wrapf(desired_angle - rotation, -PI, PI)
	rotation += clamp(angle_diff, -turn_speed * delta, turn_speed * delta)

	var forward = Vector2.RIGHT.rotated(rotation)
	apply_central_force(forward * acceleration * delta)

	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

func _process(delta):
	if drilling_target and damage_timer.time_left == 0:
		print_debug("DAMAGE TAKEN")
		drilling_target.take_damage(damage)
		damage_timer.start(damage_rate)

func emit_damage(_rotation: Vector2):
	var vfx: CPUParticles2D = vxf_damage_scene.instantiate()
	vfx.rotation = _rotation.angle()
	vfx.emitting = true
	vfx.finished.connect(func(): vfx.queue_free())
	add_child(vfx)

func destroy():
	queue_free()

func take_damage(dmg: int, vector: Vector2):
	current_hp -= dmg
	emit_damage(vector)
	if current_hp <= 0:
		destroy()

func _on_drill_toched(body):
	if body.is_in_group("player"):
		drilling_target = body

func _on_drill_stop(body):
	if body.is_in_group("player"):
		drilling_target = null
