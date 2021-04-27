extends Area2D

signal leaving_level

func _on_Stairs_body_entered(body):
	if body == get_parent().get_node("Player"):
		emit_signal("leaving_level")
