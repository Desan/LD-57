class_name Level
extends Node2D

static var G: Level

@export var submarine: Node2D
@export var ui_player_hp: Label

func _ready():
	if G != null: return
	G = self
