extends Area2D

var hp = 5

func _ready():
	pass
	
#func _process(delta):
	
	
#gets called by fire
func destroy():
	queue_free()

func _on_Fireball_body_entered(body):
	if body.is_in_group("walls"):
		queue_free()
	elif body.is_in_group("player"):
		body.touchedflame()


func _on_Fireball_area_entered(area):
	if area.is_in_group("water"):
		area.destroy()
		hp -= 1
	if hp < 1:
		Globals.score += 100
		queue_free()
