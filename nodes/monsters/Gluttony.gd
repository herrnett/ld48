extends KinematicBody2D

const regular_speed = 20
var run_speed = 20
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)

func touchedflame():
	pass
	
func reset_speed():
	run_speed = regular_speed

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"): 
		player = body
		reset_speed()

func _on_DetectRadius_body_exited(body):
	player = null
	reset_speed()

func _on_HurtBox_area_entered(area):
	if area.is_in_group("water"): 
		area.destroy()
		run_speed = 0 
		scale.x += 0.005
		scale.y += 0.005
		if scale.x > 2:
			#EXPLOSIONSANIMATION EINFÜGEN
			queue_free()
