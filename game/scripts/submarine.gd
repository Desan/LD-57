extends AnimatableBody2D

@onready var main_camera = %MainCamera
@onready var light_beam = $LightBeam
@export var rotation_speed := 5.0

@export var bullet_scene : PackedScene
@export var hook_scene: PackedScene

@export var max_hp: int = 100
var current_hp: int

@export var fire_rate := 0.2  # Delay between shots in seconds
var time_since_last_shot := 0.0

@export var speed = 100.0
var direction = Vector2.DOWN

var is_hook_ready: bool = true
@onready var hook_point = $HookPoint

func _ready():
	current_hp = max_hp
	update_hp_label.call_deferred()
	EventBus.hook_retacted.connect(reset_hook)
	EventBus.hook_retacted.connect(collect_crate)

func _physics_process(delta):
	position += direction * speed * delta

func _process(delta):
	_process_light_beam(delta)
	_process_fire(delta)
	
func _process_light_beam(delta):
	#var mouse_pos = get_viewport().get_mouse_position()
	var to_mouse = main_camera.global_position - global_position
	var target_angle = to_mouse.angle() - PI / 2
	light_beam.rotation = lerp_angle(light_beam.rotation, target_angle, rotation_speed * delta)

func _process_fire(delta):
	time_since_last_shot += delta

	# Fire when the mouse is clicked and enough time has passed since the last shot
	if Input.is_action_pressed("file_bullet") and time_since_last_shot >= fire_rate:
		fire_bullet()
		time_since_last_shot = 0.0
		
	if Input.is_action_just_pressed("fire_hook") and is_hook_ready:
		is_hook_ready = false
		fire_hook()
		
func fire_hook():
	var hook = hook_scene.instantiate()

	hook.hook_point = hook_point
	hook.position = hook_point.global_position
	hook.rotation = light_beam.rotation + deg_to_rad(90)

	get_parent().add_child(hook)

func fire_bullet():
	var bullet = bullet_scene.instantiate()

	bullet.position = position
	bullet.rotation = light_beam.rotation + deg_to_rad(90)
	light_beam.rotation += randf_range(deg_to_rad(-5), deg_to_rad(5))
	
	main_camera.start_shake(0.5)

	get_parent().add_child(bullet)

func reset_hook():
	is_hook_ready = true

func update_hp_label():
	Level.G.ui_player_hp.text = str(current_hp)

func take_damage(damage: int):
	current_hp -= damage
	if current_hp <= 0:
		EventBus.game_over.emit()
	update_hp_label()

func collect_crate():
	current_hp += randi_range(5, 15)
	update_hp_label()
