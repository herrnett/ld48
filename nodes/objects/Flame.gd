extends Area2D

var hp = 50

func _ready():
	pass

func _on_Flame_area_entered(area):
	if area.is_in_group("water"):
		area.destroy()
		hp -= 1
	if hp < 1:
		Globals.score += 50
		queue_free()

func _on_Flame_body_entered(body):
	#workaround b/c new map touches flames otherwise
	if !body.is_in_group("walls") or body.is_in_group("satan"): body.touchedflame()
	#keep this for later identification of problem. replace ouch with id of body maybe?
	#else: print("ouch") 
