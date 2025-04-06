class_name Collectable
extends RigidBody2D

var is_grabbed = false

func collect():
	pass

func grab(parent: Node2D):
	freeze = true
	is_grabbed = true
	reparent(parent)
