extends Area2D


func _on_Fountain_body_entered(body):
	var player = get_parent().get_node("Player") 
	if body == player:
		Globals.refilling = true


func _on_Fountain_body_exited(body):
	Globals.refilling = false
