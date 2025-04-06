class_name Level
extends Node2D

static var G: Level

@export var submarine: Node2D
@export var ui_player_hp: Label

@export var game_over_modal: Control

func _ready():
	if G != null: return
	G = self
	EventBus.game_over.connect(show_game_over_modal)
	
func show_game_over_modal():
	game_over_modal.show()

func restart_game():
	print_debug("restart")
	get_tree().reload_current_scene()
