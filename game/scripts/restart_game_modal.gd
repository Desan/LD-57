extends CanvasLayer

@onready var button = $Control/Panel/CenterContainer/VBoxContainer/Button

func _ready():
	button.pressed.connect(restart_game)
	
func restart_game():
	get_tree().reload_current_scene()
