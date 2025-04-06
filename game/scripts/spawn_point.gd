extends Node2D

@export var enemy: PackedScene
@export var time_to_spawn: float = 20.0
@export var is_incremental: bool = true
@onready var timer = $Timer

var wave_count: int = 0

func _ready():
	start_cycle()
	timer.timeout.connect(start_cycle)

func start_cycle():
	wave_count += 1
	if not is_incremental: wave_count = 1
	timer.start(time_to_spawn)
	for n in wave_count:
		await get_tree().create_timer(randf_range(0.1, 1.0)).timeout
		spawn_enemy()

func spawn_enemy():
	var enemy_instance: Node2D = enemy.instantiate()
	var random_x = randf_range(-100.0, 100.0)
	var random_y = randf_range(-100.0, 100.0)
	
	enemy_instance.position = Vector2(random_x, random_y)
	enemy_instance.rotation = randf_range(0.0, 360.0)
	add_child(enemy_instance)
