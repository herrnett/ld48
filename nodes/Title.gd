extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	Globals.reset()
	Musicplayer.play()

func _input(event):
	if (event is InputEventKey) or (event is InputEventMouseButton):
		Scenechanger.change_scene("res://nodes/World.tscn", true)
